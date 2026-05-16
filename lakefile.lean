import Lake
open Lake DSL

package «SIDE-bijection» where
  -- Federation-disciplined: own toolchain, no Mathlib dependency
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩
  ]

@[default_target]
lean_lib SIDEBijection where
  -- Library configuration
