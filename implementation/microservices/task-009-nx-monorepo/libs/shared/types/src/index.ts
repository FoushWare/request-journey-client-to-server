// Shared TypeScript interfaces and DTOs used across all Notes App microservices
// Import in any service: import { Note, CreateNoteDto } from '@notes-app/shared/types';

// ─────────────────────────────────────────────────────────────
// Note
// ─────────────────────────────────────────────────────────────
export interface Note {
  id: string;
  title: string;
  content: string;
  userId: string;
  tags: string[];
  isArchived: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateNoteDto {
  title: string;
  content: string;
  tags?: string[];
}

export interface UpdateNoteDto {
  title?: string;
  content?: string;
  tags?: string[];
  isArchived?: boolean;
}

// ─────────────────────────────────────────────────────────────
// User
// ─────────────────────────────────────────────────────────────
export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

export interface CreateUserDto {
  email: string;
  password: string;
  name: string;
}

// ─────────────────────────────────────────────────────────────
// Auth
// ─────────────────────────────────────────────────────────────
export interface AuthTokenPayload {
  sub: string;       // user ID
  email: string;
  iat: number;       // issued at
  exp: number;       // expires at
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  user: User;
}

// ─────────────────────────────────────────────────────────────
// Kafka Events
// ─────────────────────────────────────────────────────────────
export interface NoteCreatedEvent {
  eventType: 'note.created';
  noteId: string;
  userId: string;
  title: string;
  timestamp: string;
}

export interface UserRegisteredEvent {
  eventType: 'user.registered';
  userId: string;
  email: string;
  name: string;
  timestamp: string;
}

export interface EmailRequestEvent {
  eventType: 'email.send';
  to: string;
  subject: string;
  template: 'welcome' | 'note-shared' | 'password-reset';
  data: Record<string, unknown>;
}

// ─────────────────────────────────────────────────────────────
// API Response
// ─────────────────────────────────────────────────────────────
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}
