// Saga Pattern Example: Create Note with User Profile Update
// Choreography-based Saga

const EventEmitter = require('events');

class SagaOrchestrator extends EventEmitter {
  constructor() {
    super();
    this.sagas = new Map();
  }

  // Start a saga
  async startSaga(sagaId, steps) {
    this.sagas.set(sagaId, {
      steps,
      currentStep: 0,
      completed: [],
      compensating: []
    });

    try {
      await this.executeStep(sagaId, 0);
    } catch (error) {
      await this.compensate(sagaId);
      throw error;
    }
  }

  // Execute a saga step
  async executeStep(sagaId, stepIndex) {
    const saga = this.sagas.get(sagaId);
    if (!saga || stepIndex >= saga.steps.length) {
      return;
    }

    const step = saga.steps[stepIndex];
    console.log(`Executing step ${stepIndex}: ${step.name}`);

    try {
      const result = await step.execute();
      saga.completed.push({ step: stepIndex, result });
      saga.currentStep = stepIndex + 1;

      // Continue to next step
      if (stepIndex + 1 < saga.steps.length) {
        await this.executeStep(sagaId, stepIndex + 1);
      } else {
        console.log(`Saga ${sagaId} completed successfully`);
        this.emit('saga-completed', sagaId);
      }
    } catch (error) {
      console.error(`Step ${stepIndex} failed:`, error);
      throw error;
    }
  }

  // Compensate for failed saga
  async compensate(sagaId) {
    const saga = this.sagas.get(sagaId);
    if (!saga) return;

    console.log(`Compensating saga ${sagaId}`);

    // Compensate in reverse order
    for (let i = saga.completed.length - 1; i >= 0; i--) {
      const completedStep = saga.completed[i];
      const step = saga.steps[completedStep.step];
      
      if (step.compensate) {
        try {
          await step.compensate(completedStep.result);
          console.log(`Compensated step ${completedStep.step}`);
        } catch (error) {
          console.error(`Compensation failed for step ${completedStep.step}:`, error);
        }
      }
    }

    this.emit('saga-compensated', sagaId);
  }
}

// Example: Create Note Saga
const orchestrator = new SagaOrchestrator();

const createNoteSaga = {
  sagaId: 'create-note-123',
  steps: [
    {
      name: 'Create Note',
      execute: async () => {
        // Call Notes Service
        const response = await axios.post('http://notes-service:3002/notes/create', {
          title: 'My Note',
          content: 'Note content'
        });
        return { noteId: response.data.id };
      },
      compensate: async (result) => {
        // Delete the note
        await axios.delete(`http://notes-service:3002/notes/${result.noteId}`);
      }
    },
    {
      name: 'Update User Stats',
      execute: async (previousResult) => {
        // Call User Service to update note count
        await axios.put(`http://user-service:3003/users/stats`, {
          notesCount: '+1'
        });
        return { updated: true };
      },
      compensate: async (result) => {
        // Revert note count
        await axios.put(`http://user-service:3003/users/stats`, {
          notesCount: '-1'
        });
      }
    }
  ]
};

// Execute saga
orchestrator.startSaga(createNoteSaga.sagaId, createNoteSaga.steps)
  .then(() => console.log('Saga completed'))
  .catch(error => console.error('Saga failed:', error));

module.exports = { SagaOrchestrator };

