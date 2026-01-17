#!/bin/bash
# setup-spec-kit.sh - Install and initialize GitHub Spec-Kit for Request-Journey

set -e

echo "🌱 Setting up GitHub Spec-Kit for Request-Journey Project"
echo "========================================================="
echo ""

# Step 1: Check prerequisites
echo "✓ Checking prerequisites..."
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git first."
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11+"
    exit 1
fi

echo "✓ Git and Python 3 found"
echo ""

# Step 2: Install uv
echo "📦 Checking/Installing uv package manager..."
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    if command -v brew &> /dev/null; then
        brew install uv
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source $HOME/.cargo/env
    fi
else
    echo "✓ uv already installed"
fi

uv --version
echo ""

# Step 3: Install Specify CLI
echo "🔧 Installing Specify CLI..."
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
echo "✓ Specify CLI installed"
echo ""

# Step 4: Verify installation
echo "✓ Verifying Specify installation..."
specify check
echo ""

# Step 5: Get AI preference
echo "🤖 Which AI assistant do you want to use?"
echo "   1) Claude"
echo "   2) GitHub Copilot"
echo "   3) Cursor"
echo "   4) Windsurf"
echo "   5) Other"
read -p "Choose (1-5): " ai_choice

case $ai_choice in
    1) AI_AGENT="claude" ;;
    2) AI_AGENT="copilot" ;;
    3) AI_AGENT="cursor-agent" ;;
    4) AI_AGENT="windsurf" ;;
    5) read -p "Enter AI agent name: " AI_AGENT ;;
    *) AI_AGENT="claude" ;;
esac

# Step 6: Initialize project
echo ""
echo "🚀 Initializing Spec-Kit in current project..."
echo "Using AI Agent: $AI_AGENT"
echo ""

cd "$(dirname "$0")"
specify init . --ai "$AI_AGENT" --here --force

echo ""
echo "✅ Spec-Kit Setup Complete!"
echo ""
echo "📚 Next Steps:"
echo "1. Open your AI assistant/IDE"
echo "2. Use /speckit.constitution to define project principles"
echo "3. Use /speckit.specify to write requirements"
echo "4. Use /speckit.plan to define technical architecture"
echo "5. Use /speckit.tasks to generate task breakdown"
echo "6. Use /speckit.implement to execute all tasks"
echo ""
echo "📖 Documentation:"
echo "   - See SPEC_KIT_INTEGRATION.md for detailed guide"
echo "   - Official docs: https://github.github.io/spec-kit/"
echo ""
