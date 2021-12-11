#!/usr/local/bin/apl


filename ← ⎕ARG[4]
days ← ⍎⊃⎕ARG[5]
f ← ⎕FIO[3] ⊃filename
d ← ⎕FIO[6] f
⎕ ← d ← d[⍸∼d∈10 44]-48
⎕ ← do ← +/ ((⍳9)-1) ∘.= d
days

∇ r ← dummy advance data
  r ← data - 1
  mask ← 0 > r
  nnew ← +/mask
  new ← nnew⍴8
  r[⍸mask] ← 6
  r ← r,new
∇

∇ r ← dummy optadvance data
  r ← 1⌽data
  r[7] ← r[7] + r[9]
  ⍝ ⎕ ← r
∇

∇ r ← n run x
  control ← ⍳n+1
  control[n+1] ← ⊂x
  r ← advance/control
∇

∇ r ← n optrun x
  control ← ⍳n+1
  control[n+1] ← ⊂x
  r ← optadvance/control
∇

⍝ Unoptimized -- leads to workspace overflow
⍝ z ← days run d
⍝ 'Answer:' 
⍝ ⍴⊃z

zo ← days optrun do
'Answer (opt):' 
+/⊃zo

)OFF
