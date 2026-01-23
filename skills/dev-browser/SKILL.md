---
name: dev-browser
description: "Browser-based UI verification for frontend stories. Use when verifying UI changes, taking screenshots, or interacting with web elements. Triggers on: verify in browser, check ui, test frontend, screenshot, browser test, visual verification."
---

# Dev Browser - UI Verification

Verify frontend changes by interacting with the application in a browser.

---

## The Job

1. Ensure the dev server is running
2. Navigate to the relevant page
3. Verify UI elements exist and work correctly
4. Report verification results (pass/fail with details)

---

## Prerequisites

Before browser verification:

1. **Check if dev server is running** - Look for existing process or start one
2. **Know the URL** - Usually `http://localhost:3000` or similar (check package.json scripts)
3. **Know what to verify** - Reference the story's acceptance criteria

---

## Step 1: Start Dev Server (If Needed)

Check if the dev server is already running:

```bash
# Check if port is in use
lsof -i :3000  # or whatever port the app uses
```

If not running, start it in the background (user's terminal) or instruct the user to start it:

```
The dev server needs to be running. Please run:
npm run dev
# or
pnpm dev
# or check package.json for the correct command
```

**Important:** Do NOT run the dev server in the agent terminal - it blocks execution. Ask the user to run it or verify it's already running.

---

## Step 2: Navigate to the Page

Use the web browser tool to navigate to the specific page being tested:

```
Navigate to: http://localhost:3000/[relevant-path]
```

Choose the path based on what the story changes:
- Dashboard changes → `/dashboard` or `/`
- Task list → `/tasks`
- Settings → `/settings`
- Specific feature → check the codebase for routes

---

## Step 3: Verify UI Elements

For each acceptance criterion, check:

### Element Existence
- Is the element visible on the page?
- Does it have the correct text/label?
- Is it in the expected location?

### Element Styling
- Correct colors (check badges, buttons, status indicators)
- Proper spacing and alignment
- Responsive behavior if relevant

### Interactions
- Buttons are clickable
- Dropdowns open and show options
- Forms accept input
- Modals appear when triggered

### Data Display
- Correct data is shown
- Lists populate properly
- Empty states display when appropriate

---

## Step 4: Take Screenshots (Optional)

Take screenshots for:
- Before/after comparisons
- Documenting the final state
- Evidence of verification

Screenshot naming convention:
```
[story-id]-[description].png
# Example: US-003-priority-dropdown.png
```

---

## Step 5: Report Results

### If Verification Passes

Document in progress.txt:
```
- Browser verification: PASSED
  - [Element] displays correctly
  - [Interaction] works as expected
  - Screenshot: [filename] (if taken)
```

### If Verification Fails

Document the failure clearly:
```
- Browser verification: FAILED
  - Expected: [what should happen]
  - Actual: [what actually happened]
  - Screenshot: [filename] (if taken)
```

Then either:
1. Fix the issue and re-verify
2. Mark story as not passing with notes explaining the failure

---

## Common Verification Patterns

### Badge/Status Indicator
```
1. Navigate to page with items
2. Locate the badge element
3. Verify correct color/text for each status
4. Verify badge is visible without hover
```

### Dropdown/Select
```
1. Navigate to page with dropdown
2. Click to open dropdown
3. Verify all expected options appear
4. Select an option
5. Verify selection is saved/displayed
```

### Modal/Dialog
```
1. Navigate to page
2. Trigger the modal (click button, etc.)
3. Verify modal appears with correct content
4. Test modal interactions (close, submit)
5. Verify modal closes properly
```

### Form Submission
```
1. Navigate to form page
2. Fill in required fields
3. Submit the form
4. Verify success feedback
5. Verify data persisted (refresh and check)
```

### Filter/Search
```
1. Navigate to list page
2. Apply filter
3. Verify list updates correctly
4. Verify URL updates (if applicable)
5. Refresh and verify filter persists
```

---

## Troubleshooting

### Page Not Loading
- Check dev server is running
- Check correct port
- Check for console errors

### Element Not Found
- Check if page finished loading
- Check selector is correct
- Check if element is conditionally rendered

### Interaction Not Working
- Check for JavaScript errors in console
- Check if element is disabled
- Check if there are overlapping elements

### Data Not Showing
- Check API calls in network tab
- Check for errors in server logs
- Verify database has expected data

---

## Integration with Ralph

This skill is used when a story has the acceptance criterion:
```
"Verify in browser using dev-browser skill"
```

Ralph should:
1. Complete the implementation
2. Run typecheck/lint/tests
3. Load this skill
4. Perform browser verification
5. Only mark story as passing if verification succeeds

---

## Checklist

Before marking UI verification complete:

- [ ] Dev server is running
- [ ] Navigated to correct page
- [ ] All acceptance criteria verified visually
- [ ] Interactions tested (if applicable)
- [ ] No console errors
- [ ] Results documented in progress.txt
