/-
Copyright (c) 2026 J. York Seale. All rights reserved.
SPDX-License-Identifier: MIT

Authors: J. York Seale (ORCID: 0009-0008-7993-0310)

The PLACE TO STAND Research Programme — SIDE-bijection kernel
SIDEBijection/Theorem.lean

# The Identity-Formation Bijection at Corpus Level

This file formalizes the corpus-level Identity-Formation Bijection
theorem as stated in IDENTITY_FORMATION_BIJECTION.md (canonical source
paper).

## Theorem statement (from the canonical source paper)

For any IDS-amenable system X with formation (n₁, n₂, n₃, n₄):

  (a) Each mechanism class C_{k,j} has exactly one generalized identity
      element e_{k,j}                                    (Lemma 2.1)

  (b) Mechanism classes at the same stage have distinct identity
      elements                                            (Lemma 3.1)

  (c) Every generalized identity element belongs to some mechanism
      class                                               (Lemma 4.1)

  (d) The map C_{k,j} ↦ e_{k,j} is a bijection from mechanism classes
      to generalized identity elements

  (e) The generalized identity count equals the formation count:
      |{e_{k,j}}| = Σ_k n_k = n

## What this file establishes

Statement (a) is encoded by `identityOf` being a function; statements
(b) and (c) are assumed as the `IDSSystem` fields `distinctness` and
`noOrphans`, and (d) is proved as their conjunction, at vanilla Lean 4
level.  Statement (e) is not stated in this file (only the instance
total 2 + 3 + 2 + 0 = 7 at `sideIDS`); the cardinality equality would
need Fintype machinery from Mathlib.

## Canonical citation

After this kernel compiles, the canonical citation for the
Identity-Formation Bijection is:

  SIDEBijection.identity_formation_bijection

The varying theorem-numbers across documents (Theorem 5.1 in the
canonical source paper, Theorem 18.1 in CORPUS_CATALOGOS_v8_2,
Theorem 5.1 in A_METHODOLOGY_FOR_DETERMINED_SYSTEMS_v0_2) are
working-draft artifacts. The Lean kernel theorem is the
numbering-free canonical reference.

## Build

Vanilla Lean 4. No Mathlib. No sorry. No axioms.

  lake build
-/

namespace SIDEBijection

/-! ## Preliminaries: function properties without Mathlib -/

/-- A function is injective iff equal outputs imply equal inputs. -/
def Injective {α β : Type} (f : α → β) : Prop :=
  ∀ a₁ a₂ : α, f a₁ = f a₂ → a₁ = a₂

/-- A function is surjective iff every output is hit by some input. -/
def Surjective {α β : Type} (f : α → β) : Prop :=
  ∀ b : β, ∃ a : α, f a = b

/-- A function is bijective iff it is both injective and surjective. -/
def Bijective {α β : Type} (f : α → β) : Prop :=
  Injective f ∧ Surjective f

/-! ## Formation structure -/

/-- A formation tuple captures the stage-decomposition of a determined
specification: n₁ primitive operations, n₂ transformations, n₃ outputs,
n₄ interfaces. -/
structure Formation where
  n1 : Nat  -- primitive stage
  n2 : Nat  -- transformation stage
  n3 : Nat  -- output stage
  n4 : Nat  -- interface stage

/-- The total formation count is the sum of the stage counts. -/
def Formation.total (f : Formation) : Nat :=
  f.n1 + f.n2 + f.n3 + f.n4

/-! ## IDS-amenable systems -/

/-- An IDS-amenable system carries:
  • a formation tuple,
  • a type of mechanism classes for each formation stage,
  • a type of generalized identity elements for each formation stage,
  • an assignment from each class to its identity element (Lemma 2.1
    is encoded by this being a function),
  • the distinctness condition (Lemma 3.1: same-stage classes have
    distinct identities),
  • the no-orphans condition (Lemma 4.1: every identity belongs to
    some class).

The structure encodes the conditions as fields; the theorem then
follows by combining them. -/
structure IDSSystem where
  /-- The formation tuple of this system. -/
  formation : Formation
  /-- Mechanism classes at each formation stage. Stages indexed by
      Fin 4: 0 ↦ primitive, 1 ↦ transformation, 2 ↦ output,
      3 ↦ interface. -/
  MechClass : Fin 4 → Type
  /-- Generalized identity elements at each formation stage. -/
  IdentElem : Fin 4 → Type
  /-- The Lemma 2.1 assignment: each mechanism class has its identity
      element. -/
  identityOf : (stage : Fin 4) → MechClass stage → IdentElem stage
  /-- Lemma 3.1: same-stage mechanism classes have distinct identity
      elements (the identity-assignment is injective per stage). -/
  distinctness : (stage : Fin 4) → Injective (identityOf stage)
  /-- Lemma 4.1: every identity element comes from some mechanism class
      (the identity-assignment is surjective per stage). -/
  noOrphans : (stage : Fin 4) → Surjective (identityOf stage)

/-! ## The bijection theorem -/

/-- **The Identity-Formation Bijection (statement (d)), hypothesis-assumed.**

For any `IDSSystem`, whose fields assume the per-stage
identity-assignment injective (`distinctness`) and surjective
(`noOrphans`), the assignment is a bijection at each stage — the
conjunction of those two fields. -/
theorem identity_formation_bijection (S : IDSSystem) :
    ∀ stage : Fin 4, Bijective (S.identityOf stage) := by
  intro stage
  exact ⟨S.distinctness stage, S.noOrphans stage⟩

/-! ## Per-statement lemmas -/

/-- **Statement (a): existence and uniqueness.**

In the formalization, statement (a) is encoded directly by the type of
`identityOf` — it is a function from mechanism classes to identity
elements, so each class has exactly one identity.  No proof is required
beyond noting the type signature.

This lemma records the fact explicitly for citation purposes. -/
theorem statement_a_existence_uniqueness (S : IDSSystem)
    (stage : Fin 4) (C : S.MechClass stage) :
    ∃ e : S.IdentElem stage, S.identityOf stage C = e := by
  exact ⟨S.identityOf stage C, rfl⟩

/-- **Statement (b): same-stage classes have distinct identities.**

Direct restatement of the `distinctness` field. -/
theorem statement_b_distinctness (S : IDSSystem) (stage : Fin 4) :
    ∀ C₁ C₂ : S.MechClass stage,
      S.identityOf stage C₁ = S.identityOf stage C₂ → C₁ = C₂ :=
  S.distinctness stage

/-- **Statement (c): every identity element comes from some class.**

Direct restatement of the `noOrphans` field. -/
theorem statement_c_no_orphans (S : IDSSystem) (stage : Fin 4) :
    ∀ e : S.IdentElem stage, ∃ C : S.MechClass stage,
      S.identityOf stage C = e :=
  S.noOrphans stage

/-- **Statement (d): the assignment is a bijection at each stage.**

Already given by `identity_formation_bijection`; restated here under the
paper's labeling for symmetry of the per-statement record. -/
theorem statement_d_bijection (S : IDSSystem) :
    ∀ stage : Fin 4, Bijective (S.identityOf stage) :=
  identity_formation_bijection S

/-! ## Statement (e): the count equality

The corpus-paper statement (e) asserts |{e_{k,j}}| = Σ_k n_k = n: the
cardinality of the set of identity elements equals the formation total.

In vanilla Lean 4 without Mathlib, cardinality of a type is not
directly definable for an arbitrary `Type`; this requires `Fintype`
instances and counting machinery from Mathlib.  Statement (e) is not
stated in this file (no named proposition carries it).

With `Fintype` in scope it would follow from a per-stage bijection
(`Fintype.card_eq_of_bijective`, or its Mathlib name), which here is
the conjunction of the assumed fields `distinctness` and `noOrphans`. -/

/-! ## A concrete instance — the SIDE formation (2,3,2,0)

Closes the W-11 constructive item (loom, 2026-07-15): the `IDSSystem`
schema is here *demonstrated at a concrete instance* grounded in the
actual SIDE formation tuple (n₁,n₂,n₃,n₄) = (2,3,2,0), total 7 — no
longer an abstract `Fin 4 → Type` with hypothesis-assumed fields.  At
each stage the mechanism classes and identity elements are the concrete
finite type `Fin (sideStageCount stage)`, and the identity-assignment is
the concrete identity bijection, so `distinctness` and `noOrphans` are
*proved here, not assumed*.  `identity_formation_bijection` then fires on
a fully concrete system, and the formation total is decidably 7.

(A Trivium-sourced instance — building the per-stage maps from
`SIDE-trivium`'s `trivium_theorem` `MechanismClass ≃ QuadraticDiscriminant`
— would additionally tie the instance to the seven quadratic
discriminants, at the cost of a cross-kernel Mathlib dependency edge;
that is left as an option, the federation convention preferring this
standalone vanilla instance.) -/

/-- Per-stage class count for the SIDE formation (2,3,2,0): primitive 2,
transformation 3, output 2, interface 0. -/
def sideStageCount (stage : Fin 4) : Nat :=
  match stage.val with
  | 0 => 2
  | 1 => 3
  | 2 => 2
  | _ => 0

/-- The concrete SIDE IDS-amenable system: at each stage the mechanism
classes and identity elements are `Fin (sideStageCount stage)`, and the
identity-assignment is the concrete identity bijection. -/
def sideIDS : IDSSystem where
  formation := ⟨2, 3, 2, 0⟩
  MechClass := fun stage => Fin (sideStageCount stage)
  IdentElem := fun stage => Fin (sideStageCount stage)
  identityOf := fun _ x => x
  distinctness := fun _ _ _ h => h
  noOrphans := fun _ b => ⟨b, rfl⟩

/-- **The schema, demonstrated at the concrete instance.** The formerly
abstract `identity_formation_bijection` now fires on a fully concrete,
never-vacuous system. -/
theorem sideIDS_bijection :
    ∀ stage : Fin 4, Bijective (sideIDS.identityOf stage) :=
  identity_formation_bijection sideIDS

/-- The concrete instance's formation total is 2 + 3 + 2 + 0 = 7 (`rfl`);
the count of its identity elements, statement (e), is not stated. -/
theorem sideIDS_total_seven : sideIDS.formation.total = 7 := rfl

end SIDEBijection
