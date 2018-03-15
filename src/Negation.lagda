---
title     : "Negation: Negation, with Intuitionistic and Classical Logic"
layout    : page
permalink : /Negation
---

This chapter introduces negation, and discusses intuitionistic
and classical logic.

## Imports

\begin{code}
open import Isomorphism using (_≃_; ≃-sym; ≃-trans; _≲_)
open import Data.Empty using (⊥; ⊥-elim)
open import Data.Sum using (_⊎_; inj₁; inj₂)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Function using (_∘_)
\end{code}


## Negation

Given a proposition `A`, the negation `¬ A` holds if `A` cannot hold.
We formalise this idea by declaring negation to be the same
as implication of false. 
\begin{code}
¬_ : Set → Set
¬ A = A → ⊥
\end{code}
This is a form of *proof by contradiction*: if assuming `A` leads
to the conclusion `⊥` (a contradiction), then we must have `¬ A`.

Evidence that `¬ A` holds is of the form

    λ{ x → N }

where `N` is a term of type `⊥` containing as a free variable `x` of type `A`.
In other words, evidence that `¬ A` holds is a function that converts evidence
that `A` holds into evidence that `⊥` holds.

Given evidence that both `¬ A` and `A` hold, we can conclude that `⊥` holds.
In other words, if both `¬ A` and `A` hold, then we have a contradiction.
\begin{code}
¬-elim : ∀ {A : Set} → ¬ A → A → ⊥
¬-elim ¬x x = ¬x x
\end{code}
Here we write `¬x` for evidence of `¬ A` and `x` for evidence of `A`.  This
means that `¬x` must be a function of type `A → ⊥`, and hence the application
`¬x x` must be of type `⊥`.  Note that this rule is just a special case of `→-elim`.

We set the precedence of negation so that it binds more tightly
than disjunction and conjunction, but less tightly than anything else.
\begin{code}
infix 3 ¬_
\end{code}
Thus, `¬ A × ¬ B` parses as `(¬ A) × (¬ B)` and `¬ m ≡ n` as `¬ (m ≡ n)`.

In *classical* logic, we have that `A` is equivalent to `¬ ¬ A`.
As we discuss below, in Agda we use *intuitionistic* logic, where
we have only half of this equivalence, namely that `A` implies `¬ ¬ A`.
\begin{code}
¬¬-intro : ∀ {A : Set} → A → ¬ ¬ A
¬¬-intro x ¬x = ¬x x
\end{code}
Let `x` be evidence of `A`. We will show that assuming
`¬ A` leads to a contradiction, and hence `¬ ¬ A` must hold.
Let `¬x` be evidence of `¬ A`.  Then from `A` and `¬ A`
we have a contradiction (evidenced by `¬x x`).  Hence, we have
shown `¬ ¬ A`.

We cannot show that `¬ ¬ A` implies `A`, but we can show that
`¬ ¬ ¬ A` implies `¬ A`.
\begin{code}
¬¬¬-elim : ∀ {A : Set} → ¬ ¬ ¬ A → ¬ A
¬¬¬-elim ¬¬¬x x = ¬¬¬x (¬¬-intro x)
\end{code}
Let `¬¬¬x` be evidence of `¬ ¬ ¬ A`. We will show that assuming
`A` leads to a contradiction, and hence `¬ A` must hold.
Let `x` be evidence of `A`. Then by the previous result, we
can conclude `¬ ¬ A` (evidenced by `¬¬-intro x`).  Then from
`¬ ¬ ¬ A` and `¬ ¬ A` we have a contradiction (evidenced by
`¬¬¬x (¬¬-intro x)`.  Hence we have shown `¬ A`.

Another law of logic is *contraposition*,
stating that if `A` implies `B`, then `¬ B` implies `¬ A`.
\begin{code}
contraposition : ∀ {A B : Set} → (A → B) → (¬ B → ¬ A)
contraposition f ¬y x = ¬y (f x)
\end{code}
Let `f` be evidence of `A → B` and let `¬y` be evidence of `¬ B`.  We
will show that assuming `A` leads to a contradiction, and hence
`¬ A` must hold. Let `x` be evidence of `A`.  Then from `A → B` and
`A` we may conclude `B` (evidenced by `f x`), and from `B` and `¬ B`
we may conclude `⊥` (evidenced by `¬y (f x)`).  Hence, we have shown
`¬ A`.

Given the correspondence of implication to exponentiation and
false to the type with no members, we can view negation as
raising to the zero power.  This indeed corresponds to what
we know for arithmetic, where

    0 ^ n  =  1,  if n = 0
           =  0,  if n ≠ 0

Indeed, there is exactly one proof of `⊥ → ⊥`.
\begin{code}
id : ⊥ → ⊥
id x = x
\end{code}
However, there are no possible values of type `ℕ → ⊥`,
or indeed of type `A → ⊥` when `A` is anything other than `⊥` itself.


### Exercise (`⊎-dual-×`)

Show that conjunction, disjunction, and negation are related by a
version of De Morgan's Law.
\begin{code}
⊎-Dual-× : Set₁
⊎-Dual-× = ∀ {A B : Set} → ¬ (A ⊎ B) ≃ (¬ A) × (¬ B)
\end{code}
Show there is a term of type `⊎-Dual-×`.
This result is an easy consequence of something we've proved previously.

Is there also a term of the following type?
\begin{code}
×-Dual-⊎ : Set₁
×-Dual-⊎ = ∀ {A B : Set} → ¬ (A × B) ≃ (¬ A) ⊎ (¬ B)
\end{code}
If so, prove; if not, explain why.


## Intuitive and Classical logic

In Gilbert and Sullivan's *The Gondoliers*, Casilda is told that
as an infant she was married to the heir of the King of Batavia, but
that due to a mix-up no one knows which of two individuals, Marco or
Giuseppe, is the heir.  Alarmed, she wails "Then do you mean to say
that I am married to one of two gondoliers, but it is impossible to
say which?"  To which the response is "Without any doubt of any kind
whatever."

Logic comes in many varieties, and one distinction is between
*classical* and *intuitionistic*. Intuitionists, concerned
by cavalier assumptions made by some logicians about the nature of
infinity, insist upon a constructionist notion of truth.  In
particular, they insist that a proof of `A ⊎ B` must show
*which* of `A` or `B` holds, and hence they would reject the
claim that Casilda is married to Marco or Giuseppe until one of the
two was identified as her husband.  Perhaps Gilbert and Sullivan
anticipated intuitionism, for their story's outcome is that the heir
turns out to be a third individual, Luiz, with whom Casilda is,
conveniently, already in love.

Intuitionists also reject the law of the excluded
middle, which asserts `A ⊎ ¬ A` for every `A`, since the law
gives no clue as to *which* of `A` or `¬ A` holds. Heyting
formalised a variant of Hilbert's classical logic that captures the
intuitionistic notion of provability. In particular, the law of the
excluded middle is provable in Hilbert's logic, but not in Heyting's.
Further, if the law of the excluded middle is added as an axiom to
Heyting's logic, then it becomes equivalent to Hilbert's.
Kolmogorov
showed the two logics were closely related: he gave a double-negation
translation, such that a formula is provable in classical logic if and
only if its translation is provable in intuitionistic logic.

Propositions as Types was first formulated for intuitionistic logic.
It is a perfect fit, because in the intuitionist interpretation the
formula `A ⊎ B` is provable exactly when one exhibits either a proof
of `A` or a proof of `B`, so the type corresponding to disjunction is
a disjoint sum.

(Parts of the above are adopted from "Propositions as Types", Philip Wadler,
*Communications of the ACM*, December 2015.)

## Excluded middle is irrefutable

The law of the excluded middle can be formulated as follows.
\begin{code}
EM : Set₁
EM = ∀ {A : Set} → A ⊎ ¬ A
\end{code}
As we noted, the law of the excluded middle does not hold in
intuitionistic logic.  However, we can show that it is *irrefutable*,
meaning that the negation of its negation is provable (and hence that
its negation is never provable).
\begin{code}
em-irrefutable : ∀ {A : Set} → ¬ ¬ (A ⊎ ¬ A)
em-irrefutable k = k (inj₂ λ{ x → k (inj₁ x) })
\end{code}
The best way to explain this code is to develop it interactively.

    em-irrefutable k = ?

Given evidence `k` that `¬ (A ⊎ ¬ A)`, that is, a function that give a
value of type `A ⊎ ¬ A` returns a value of the empty type, we must fill
in `?` with a term that returns a value of the empty type.  The only way
we can get a value of the empty type is by applying `k` itself, so let's
expand the hole accordingly.

    em-irrefutable k = k ?

We need to fill the new hole with a value of type `A ⊎ ¬ A`. We don't have
a value of type `A` to hand, so let's pick the second disjunct.

    em-irrefutable k = k (inj₂ λ{ x → ? })

The second disjunct accepts evidence of `¬ A`, that is, a function
that given a value of type `A` returns a value of the empty type.  We
bind `x` to the value of type `A`, and now we need to fill in the hole
with a value of the empty type.  Once again, he only way we can get a
value of the empty type is by applying `k` itself, so let's expand the
hole accordingly.

    em-irrefutable k = k (inj₂ λ{ x → k ? })

This time we do have a value of type `A` to hand, namely `x`, so we can
pick the first disjunct.

    em-irrefutable k = k (inj₂ λ{ x → k (inj₁ x) })

There are no holes left! This completes the proof. 

The following story illustrates the behaviour of the term we have created.
(With apologies to Peter Selinger, who tells a similar story
about a king, a wizard, and the Philosopher's stone.)

Once upon a time, the devil approached a man and made an offer:
"Either (a) I will give you one billion dollars, or (b) I will grant
you any wish if you pay me one billion dollars.
Of course, I get to choose whether I offer (a) or (b)."

The man was wary.  Did he need to sign over his soul?
No, said the devil, all the man need do is accept the offer.

The man pondered.  If he was offered (b) it was unlikely that he would
ever be able to buy the wish, but what was the harm in having the
opportunity available?

"I accept," said the man at last.  "Do I get (a) or (b)?"

The devil paused.  "I choose (b)."

The man was disappointed but not surprised.  That was that, he thought.
But the offer gnawed at him.  Imagine what he could do with his wish!
Many years passed, and the man began to accumulate money.  To get the
money he sometimes did bad things, and dimly he realized that
this must be what the devil had in mind.
Eventually he had his billion dollars, and the devil appeared again.

"Here is a billion dollars," said the man, handing over a valise
containing the money.  "Grant me my wish!"

The devil took possession of the valise.  Then he said, "Oh, did I say
(b) before?  I'm so sorry.  I meant (a).  It is my great pleasure to
give you one billion dollars."

And the devil handed back to the man the same valise that the man had
just handed to him.

(Parts of the above are adopted from "Call-by-Value is Dual to Call-by-Name",
Philip Wadler, *International Conference on Functional Programming*, 2003.)


### Exercise

Prove the following three formulas are equivalent to each other,
and to the formulas `EM` and `⊎-Dual-+` given earlier.
\begin{code}
¬¬-Elim Peirce Implication : Set₁
¬¬-Elim = ∀ {A : Set} → ¬ ¬ A → A
Peirce = ∀ {A B : Set} → (((A → B) → A) → A)
Implication = ∀ {A B : Set} → (A → B) → ¬ A ⊎ B
\end{code}

    
### Exercise (`¬-stable`, `×-stable`)

Say that a formula is *stable* if double negation elimination holds for it.
\begin{code}
Stable : Set → Set
Stable A = ¬ ¬ A → A
\end{code}
Show that any negated formula is stable, and that the conjunction
of two stable formulas is stable.
\begin{code}
¬-Stable : Set₁
¬-Stable = ∀ {A : Set} → Stable (¬ A)

×-Stable : Set₁
×-Stable = ∀ {A B : Set} → Stable A → Stable B → Stable (A × B)
\end{code}

## Standard Prelude

Definitions similar to those in this chapter can be found in the standard library.
\begin{code}
import Relation.Nullary using (¬_)
import Relation.Nullary.Negation using (contraposition)
\end{code}

## Unicode

This chapter uses the following unicode.

    ¬  U+00AC  NOT SIGN (\neg)