# Manual testing

## Environment

The test environment runs Neovim inside a sandboxed `bwrap` container with a
pre-configured `test-home/` directory that already has lazy.nvim and
arxml.nvim wired up.

```
cd test/
./test-run-nvim.sh
```

Fixture files live in `test/test-home/fixtures/` and are mapped to
`~/fixtures/` inside the sandbox.  All file paths in the steps below are as
seen from within Neovim in the sandbox.

---

## 1. Filetype detection

**Goal**: opening an `.arxml` file sets the filetype to `arxml`.

1. Open a fixture: `:e ~/fixtures/brakes_v1/BrakeSystem.arxml`
2. Run `:set filetype?`

**Expected**: `filetype=arxml`

---

## 2. Syntax highlighting

**Goal**: `<SHORT-NAME>` values are visually prominent; `UUID` attributes are
dimmed.

1. Open `~/fixtures/brakes_v1/BrakeSystem.arxml`.
2. Observe lines that contain `<SHORT-NAME>…</SHORT-NAME>` — the text between
   the tags (e.g. `VehicleSystem`, `BrakeController`) should be rendered in a
   bold or otherwise prominent highlight (linked to the `Title` group).
3. Observe lines that contain `UUID="…"` — the whole attribute including its
   value should be rendered in a muted colour (linked to the `Comment` group,
   typically grey).

**Verify highlight groups directly:**

```
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')
```

Move the cursor onto the text between `<SHORT-NAME>` tags → should report
`arxmlShortName`.

Move the cursor onto a `UUID="…"` attribute → should report `arxmlUUID`.

---

## 3. Folding

**Goal**: elements fold by depth; the fold label shows the tag name and, when
present, the `<SHORT-NAME>` of the element.

1. Open `~/fixtures/brakes_v1/BrakeSystem.arxml`.
2. Run `zM` to close all folds.
3. The top-level `<AR-PACKAGES>` block should appear as a single fold line.
   Move the cursor to it and press `zo` to open one level.
4. `<AR-PACKAGE>` should now be visible as a fold.  Open it — the fold label
   should read something like `13  AR-PACKAGE: VehicleSystem` (line count,
   tag name, SHORT-NAME).
5. Continue opening nested folds.  A `<COMPONENT-TYPE>` fold should label as
   `BrakeController`; `<P-PORT-PROTOTYPE>` as `BrakeCommand`, etc.
6. Run `zR` to reopen all folds and verify the file looks normal.

---

## 4. Matching-tag navigation

**Goal**: `%` jumps between the opening and closing tag of an XML element.

1. Open `~/fixtures/brakes_v1/BrakeSystem.arxml`.
2. Place the cursor anywhere on the `<COMPONENT-TYPE …>` line.
3. Press `%`.

**Expected**: cursor jumps to the corresponding `</COMPONENT-TYPE>` line.

4. Press `%` again.

**Expected**: cursor returns to the opening tag.

Test a few other pairs (`<AR-PACKAGE>` / `</AR-PACKAGE>`, `<PORTS>` /
`</PORTS>`) to confirm.

---

## 5. UUID-aware diff

**Goal**: `:ARXMLDiff` opens a side-by-side diff that highlights only real
content changes; lines whose only difference is a regenerated UUID are **not**
highlighted.

The two fixture files have identical structure except:
- Every `UUID="…"` value is different between v1 and v2.
- `<SHORT-NAME>VehicleSpeed</SHORT-NAME>` in v1 became
  `<SHORT-NAME>WheelSpeed</SHORT-NAME>` in v2.

### Steps

1. Open the v1 fixture:
   ```
   :e ~/fixtures/brakes_v1/BrakeSystem.arxml
   ```

2. Run:
   ```
   :ARXMLDiff ~/fixtures/brakes_v2/BrakeSystem.arxml
   ```

3. A new tab opens with two read-only panes in diff mode.

**Expected**:
- `UUID="…"` lines are **not** highlighted as changed (all UUID values are
  replaced by `UUID=""` before diffing).
- Only the line containing `VehicleSpeed` vs `WheelSpeed` is highlighted as a
  change.

4. Confirm the pane titles in the tab-line contain `[arxml-diff]` and the
   full paths of both files.

5. Close the diff tab with `:tabclose`.

### Same-filename edge case

The two fixtures intentionally share the filename `BrakeSystem.arxml` to
exercise the name-collision fix.  The diff must open without an `E95` error.

---

## 6. LSP (optional)

Requires the companion `arxml-ls` plugin to be installed alongside `arxml.nvim`
in the lazy directory.

1. Open `~/fixtures/brakes_v1/BrakeSystem.arxml`.
2. Run `:LspInfo`.

**Expected**: an `arxml-ls` client is attached to the buffer.

If `arxml-ls` is not present the LSP silently does nothing — `:LspInfo` should
show no attached clients but no error either.
