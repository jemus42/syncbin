---
name: jamesian
description: Revise prose using Francis Christensen's generative rhetoric method with coordinate/subordinate/mixed/inverted sentence patterns and free modifiers. Trigger on "tight revision", "balanced revision", "layered revision", "expansive revision", "baroque revision" (auto-applies that preset), or "generative revision", "jamesian", "christensen" (asks for preset). Also use when user wants to transform plain prose into sophisticated architecture while maintaining accuracy through search verification.
---

# Christensen Prose Revision

This skill implements Francis Christensen's generative rhetoric method for revising prose. It transforms plain text into sophisticated structures using coordinate, subordinate, mixed, and inverted sentence patterns while maintaining factual accuracy.

## Tunable Parameters

These control density, complexity, and rhythm. The skill offers presets with memorable names, or you can customize individual parameters.

### Presets

Choose a preset by name, or customize parameters individually:

**1. TIGHT** (spare, punchy, muscular)
- MAX_CLAUSAL_DEPTH: 1
- MAX_COORDINATE_BRANCHES: 1
- MAX_WORDS_PER_SENTENCE: 20
- CHRISTENSEN_RATIO: 0.3
- *Character:* Short bursts, minimal embedding, mostly plain sentences with occasional structure for rhythm

**2. BALANCED** (controlled, precise, architectural)
- MAX_CLAUSAL_DEPTH: 1
- MAX_COORDINATE_BRANCHES: 1
- MAX_WORDS_PER_SENTENCE: 25
- CHRISTENSEN_RATIO: 0.4
- *Character:* Balanced complexity, careful construction, every modifier earns its place

**3. LAYERED** (expansive, discursive, investigative)
- MAX_CLAUSAL_DEPTH: 2
- MAX_COORDINATE_BRANCHES: 2
- MAX_WORDS_PER_SENTENCE: 35
- CHRISTENSEN_RATIO: 0.5
- *Character:* Generous embedding, coordinated phrases, room to develop ideas within sentences

**4. EXPANSIVE** (rolling, rhetorical, accumulating)
- MAX_CLAUSAL_DEPTH: 2
- MAX_COORDINATE_BRANCHES: 2
- MAX_WORDS_PER_SENTENCE: 40
- CHRISTENSEN_RATIO: 0.6
- *Character:* Longer periods, multiple modifying layers, rhythm builds through accumulation

**5. BAROQUE** (dense, ornate, maximalist)
- MAX_CLAUSAL_DEPTH: 3
- MAX_COORDINATE_BRANCHES: 2
- MAX_WORDS_PER_SENTENCE: 50
- CHRISTENSEN_RATIO: 0.7
- *Character:* Deep nesting, multiple branches, high ratio of complex sentences, ornate construction

**6. CUSTOM**
- User specifies individual parameter values

### Parameter Definitions

- **MAX_CLAUSAL_DEPTH**: Maximum levels of clause embedding
  - Value of 2 means base clause + subordinate clause + one further subordinate clause
  - Higher values create more complex nesting

- **MAX_COORDINATE_BRANCHES**: Maximum coordinated verb phrases sharing a subject
  - Value of 2 means a subject can drive at most two predicate actions
  - Each VP should be relatively light; heavy VPs count against the budget

- **MAX_WORDS_PER_SENTENCE**: Hard ceiling on sentence length
  - No sentence may exceed this count

- **CHRISTENSEN_RATIO**: Target proportion of Christensen-structured sentences
  - Value of 0.4 means ~2 in 5 sentences use complex structures
  - Remainder should be plain sentences—simple declarations, short punches, clean transitions

## Christensen Sentence Types

1. **Coordinate**: Parallel free modifiers at the same level
2. **Subordinate**: Each modifier drops a level deeper
3. **Mixed**: Coordinate opening, subordinate dive
4. **Inverted**: Modifiers first, base clause delayed

## Critical Constraints

- **Never process quotes or blockquotes**—only process main text
- Leave quotes exactly as they are
- Sentences introducing, sourcing, or attributing quotes must remain plain and descriptive
- Do not edit sourcing sentences

## 10-Step Process

### 1. Deconstruction and Drafting

- Break text into paragraphs (minimum 3 sentences each)
- Decompose each paragraph into atomic claims
- Identify controlling idea for each paragraph—the thematic center organizing the architecture
- Choose the controlling idea creating most productive tension or organizing evidence most precisely
- Assign roles to claims:
  - Which earn base-clause status
  - Which become free modifiers
  - Which should be combined or rewritten as dependent structures

### 2. Generate Christensen Structures

For each paragraph's material, generate 4 sentence structures and label by type:

- **Coordinate**: Parallel free modifiers at same level (respect MAX_COORDINATE_BRANCHES and branch weight)
- **Subordinate**: Each modifier drops a level deeper (respect MAX_CLAUSAL_DEPTH)
- **Mixed**: Coordinate opening, subordinate dive
- **Inverted**: Modifiers first, base clause delayed

### 3. Evaluation and Looping

- Evaluate which structure does most work
- Choose structure capturing idea structure most accurately, with right focus and hierarchy
- Refine the best candidate
- Replace single em dash with either:
  - New sentence start, or
  - Semicolon (depending on dependency level)
- Replace parenthetical em dashes with other punctuation where appropriate
- Try adding prepositional phrase or absolute phrase as medial free modifier if it:
  - Makes core idea more defined and less nebulous, or
  - Clarifies focus through 5Ws and H
- Try using subordinate Christensen structure with blank in controlling piece
  - Ask what should fill the blank
  - Put it in
  - Ask: is it better?
  - Announce decision

### 4. Comparison Against Original

- Print original paragraph(s) and revised paragraph(s) side by side
- Ask: is it better, or just longer?
- Decide and pick

### 5. Further Analysis and Revision

- Analyze result using search if necessary
- Determine if it makes a true and interesting point
- Announce decision
- If not, revise it
- In revision, use subordinate Christensen structure with blank in controlling piece
- Ask what belongs in blank, show work, make edit

### 6. Rhythm and Variation

- If all sentences similarly long, find candidate for shorter sentence
- Peel it off from longer sentence to vary rhythm
- Check that Coordinate, Subordinate, Mixed, and Inverted structures are not repeated in a row
- Do not stack patterns monotonously (e.g., no three inverted structures in a row)
- Count Christensen sentences versus plain sentences
- If ratio drifts far from CHRISTENSEN_RATIO, convert some to restore balance
- Usually do not exceed MAX_CLAUSAL_DEPTH levels of modification

### 7. Loop on Remaining Sentences

- Look at remaining sentences not pushed into Christensen structures
- If they form unconnected short sentences and aren't occasional short sentences for punch, repeat process
- Respect CHRISTENSEN_RATIO—not every sentence needs restructuring; some should stay plain

### 8. Mandatory Rewrites

Always rewrite the following:

- **Asyndetic tricolons**: Fold into another sentence, disperse among multiple sentences, limit to two elements, or move some to preposed clause
- **End-of-paragraph sententia**: Fold into larger sentence, extend into longer sentence with added detail, or eliminate entirely
- **Em-dashes**: Remove those that can be eliminated by folding separated clause into larger sentence, putting in own sentence, eliminating, or using alternate punctuation

### 9. Format Check

When done looping:

- Check every sentence has no more than base + MAX_CLAUSAL_DEPTH levels of modification
- Check no sentence has more than MAX_COORDINATE_BRANCHES coordinated verb phrases sharing a subject
- Verify each VP is light enough to justify its slot
- Flag any sentence exceeding either limit and provide rewrite
- Check no sentence exceeds MAX_WORDS_PER_SENTENCE words
- Verify Christensen-to-plain ratio approximates CHRISTENSEN_RATIO
- Check every sentence has clear verb in correct tense (exception: where stylistic variation truly adds enough to motivate it)
- Show final version

### 10. Factual/Referent/Conjunction and Causality/Evidence Check

**Critical accuracy verification:**

- Check revision for introduced errors
- Use search if necessary to ensure each sentence is still true or defensible
- Verify referents and anaphoric reference haven't drifted
- Check coordinating and subordinating conjunctions make truth more clear and precise
- **Do not skimp on search** when verifying claims
- Compare causal claims of initial to revision
  - Keep highly defensible claims
  - Remove false causality introduced during revision
  - Use search to verify causality is correct
- Check evidence claims are defensible and intentional—not result of mushy sentence combination
- Ensure sequence is still correct
- Verify event order and spacing hasn't been jumbled, compressed, or unintentionally removed
- Search if needed to check sequence and spacing
- Add small edits to improve cohesion if necessary
- Consider sign-posting edits for clarity and throughline

## Common LLM Patterns to Prune

During revision, eliminate these overparallelisms:

- "that [x] is the [y]" constructions
- "it's not [x]. it's [y]" constructions

## Workflow

1. **Determine preset:**
   - If user requested a specific preset by name (e.g., "tight revision", "layered revision"), use that preset directly and skip to step 2
   - If user requested "generative revision", "christensenize", or "christensen" without specifying a preset, ask user to choose:
     - Present the preset options (TIGHT, BALANCED, LAYERED, EXPANSIVE, BAROQUE, CUSTOM)
     - If user chooses CUSTOM, ask for individual parameter values
     - If user has no preference, suggest BALANCED as the default
   - Otherwise, ask user to choose preset or custom parameters with the same options as above
2. **Receive input text** to revise (if not already provided)
3. **Work through steps 1-10** systematically
4. **Show your work** at key decision points:
   - When choosing between sentence structures (step 3)
   - When comparing original vs. revised (step 4)
   - When analyzing truth and interest (step 5)
   - When checking rhythm and variation (step 6)
   - When verifying facts and causality (step 10)
5. **Present final revised text** with brief explanation of changes

## Search Integration

Use web_search tool when:

- Verifying factual claims during step 5
- Checking causality claims in step 10
- Verifying event sequences and spacing in step 10
- Adding precision and detail during sentence expansion
- Sharpening focus or argument with evidence

Search proactively to ensure no errors are introduced during the restructuring process.

## Output Format

Present revisions clearly:

- Show original paragraph(s)
- Show revised paragraph(s) under it
- Brief note on key structural changes
- Flag any sentences requiring user review
- Remind user this is an edit, and provide them an option of further back and forth revising.

Always maintain factual accuracy while improving the prose architecture.
