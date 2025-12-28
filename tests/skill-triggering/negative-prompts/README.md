# Negative Skill Triggering Tests

These prompts should NOT trigger heavyweight skills. They test that the plugin doesn't over-trigger on simple interactions.

## Expected Behavior

For each prompt in this directory, the response should:
1. NOT invoke brainstorming, writing-plans, or other heavy workflow skills
2. Answer directly without announcing skill usage
3. Complete quickly without extensive exploration

## Running Tests

Use the same test runner but verify skills are NOT invoked.
