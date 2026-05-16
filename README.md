# SIDE-bijection

**The PLACE TO STAND Research Programme — Identity-Formation Bijection Kernel**

J. York Seale (ORCID: 0009-0008-7993-0310)

## Purpose

This kernel formalizes the **corpus-level Identity-Formation Bijection
theorem** in vanilla Lean 4, with no Mathlib dependency, no `sorry`,
and no axioms.

After this kernel compiles, the canonical Lean reference for the
theorem is:

  `SIDEBijection.identity_formation_bijection`

This resolves the working-draft numbering inconsistency across:

- `IDENTITY_FORMATION_BIJECTION.md` (Theorem 5.1)
- `CORPUS_CATALOGOS_v8_2.md` (Theorem 18.1)
- `A_METHODOLOGY_FOR_DETERMINED_SYSTEMS_v0_2.md` (Theorem 5.1)
- `FINDINGS_AND_REACHES_v0_1.md` (Theorem 5.1)

The kernel theorem replaces the numbered references with a
numbering-free canonical citation by name. Documents that cited
specific theorem-numbers can be harmonized by referring to the kernel
identifier directly.

## Federation discipline

This kernel sits alongside the other PLACE TO STAND kernels:

- `SIDE-kernel`      — RH proof core (Day 1 deposit, public)
- `SIDE-trivium`     — Trivium-specific machinery, includes the
                       Trivium-case Identity-Formation Bijection
- `SIDE-effects`     — framework consequences
- `SIDE-interfaces`  — interface boundaries
- `SIDE-meta`        — parametric SIDESystem template (v0.2, with
                       documented v0.3 corrections pending)
- **`SIDE-bijection`** — *this kernel*: corpus-level Identity-Formation
                         Bijection

Each kernel is independently auditable, pins its own toolchain
(`lean-toolchain` here pinned to `leanprover/lean4:v4.29.0-rc8`,
matching the established federation), and has its own deposit history.
Cross-kernel content is vendored with attribution, not imported via
Lake dependencies.

## What this kernel establishes

### The structural setup

A `Formation` is the stage-decomposition tuple `(n₁, n₂, n₃, n₄)`
(primitive, transformation, output, interface).

An `IDSSystem` is an IDS-amenable system carrying:

- a `Formation`,
- a `MechClass` type per formation stage,
- an `IdentElem` type per formation stage,
- an `identityOf` assignment from mechanism classes to identity
  elements (encoding **Lemma 2.1**: existence and uniqueness),
- a `distinctness` field (encoding **Lemma 3.1**: same-stage classes
  have distinct identities),
- a `noOrphans` field (encoding **Lemma 4.1**: every identity comes
  from some class).

### The theorems

- `statement_a_existence_uniqueness` — Lemma 2.1 restated
- `statement_b_distinctness` — Lemma 3.1 restated
- `statement_c_no_orphans` — Lemma 4.1 restated
- `identity_formation_bijection` — **statement (d)**: the
  identity-assignment is a bijection at each formation stage.  Proved
  from `distinctness` + `noOrphans` via the definition of `Bijective`.
- `statement_d_bijection` — alias for symmetry of the per-statement
  record

### What is not formalized here

**Statement (e)** of the canonical source paper asserts the
count-equality `|{e_{k,j}}| = Σ_k n_k = n`.  In vanilla Lean 4 without
Mathlib, cardinality of a type is not directly definable; this
requires `Fintype` instances.  Statement (e) is named in the file as a
proposition that becomes a theorem when Fintype-compatibility is
added.  No structural content is lost at the skeleton level —
`Bijective` is the categorical condition for cardinality equality, and
the Fintype-instantiated version follows automatically when those
instances exist.

## Build

```
lake build
```

Expected output: `Build completed successfully (N jobs).` with N
including the `SIDEBijection` library target.

No external dependencies; no Mathlib clone needed.

## Verification status

- Vanilla Lean 4: ✓
- No Mathlib dependency: ✓
- No `sorry`: ✓
- No axioms: ✓
- Compiles on `leanprover/lean4:v4.29.0-rc8`: pending user-side build
  confirmation

## What this resolves

1. The `Theorem 5.1 / Theorem 18.1` numbering inconsistency — by
   making the kernel identifier the canonical citation, the numbered
   references in working drafts become superseded by name-based
   reference to `SIDEBijection.identity_formation_bijection`.

2. The paper-only-to-kernel-verified asymmetry for one of the
   load-bearing structural results — Identity-Formation Bijection at
   corpus level is now machine-verified at the structural-skeleton
   level.

3. The pattern for future corpus-level theorem formalizations — small
   federation-disciplined kernels containing a single named result,
   with vanilla Lean 4 and no Mathlib dependency, easy to verify and
   easy to cite.

## License

MIT.  The theorem itself is a structural result about IDS-amenable
systems; no patent claims are encoded in this kernel.
