#!/bin/bash

# Check if models file exists
if [ -f /models.txt ]; then
    echo "Found models.txt file. Pulling models..."
    
    # Read each line from models.txt and pull the model
    while IFS= read -r model || [[ -n "$model" ]]; do
        # Skip empty lines and comments (lines starting with #)
        if [[ ! -z "$model" && ! "$model" =~ ^[[:space:]]*# ]]; then
            echo "Pulling model: $model"
            ollama pull "$model"
            if [ $? -eq 0 ]; then
                echo "✅ Successfully pulled: $model"
            else
                echo "❌ Failed to pull: $model"
            fi
        fi
    done < /models.txt
else
    echo "No models.txt file found. Skipping model pulls."
fi

echo "Model setup complete!"
