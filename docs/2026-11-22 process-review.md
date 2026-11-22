---
status: active
value: [me]
horizon: now
done_looks_like: Håkan har tagit de fyra besluten nedan och steg 1 i planen är gjort
---

# Byggprocessen — analys och plan (2026-11-22)

Underlag: `claude-devteam` (v1.6.0), `workout-app`, `training-coach`, `alvar-design-system`, git-historik, HANDOFF-filer, CI-flöden, och inspirationslänkarna (Matt Pococks skills, Anthropics Managed Agents, design-skills, "loop engineering").

## Kärnan

Processen är genomtänkt och fungerar när den körs — workout-app 2026-11-20 är ett bra exempel: kriterier → mockup → plan → builder → reviewer hittar en riktig bugg → fix → om-review → merge. Kvaliteten är inte problemet.

**Problemet är att processen är byggd för att starta bra, inte för att landa.** Åtta faser, fyra grindar, och flaskhalsen är du — men inte i design eller planering, utan i *att få saker till main*. Training-coach har 50 commits på tre dagar, tester gröna, Supabase-funktionen deployad — och **ingen main-gren finns**. Två Claude-sessioner har dessutom jobbat parallellt på var sin gren (`epic-babbage` och `gallant-bardeen`) som har glidit isär. Det är ditt starter-mönster, inbyggt i verktygskedjan.

Andra insikten: **kontexten är tyngre än den behöver vara**, och det är strukturellt, inte en vanefråga. Varje dev-session bär med sig vault-regler, sälj-/juridik-/marknadsplugins och dubblerad processtext.

---

## Beslut tagna 2026-11-22

| # | Beslut | Vad det blev |
|---|---|---|
| 1 | Grindar | Du är med i idéfasen (den vill du ha kvar) och godkänner acceptanskriterierna. Design: ingen grind normalt — designsystemet och UX-reglerna i devteam bär det. Vid större UI-förändring: 3–5 alternativ, du väljer. Plan: lead-ansvar, din grind bara för large |
| 2 | Review | En: reviewer-agenten. CI-boten tas bort ur workout-app och training-coach |
| 3 | Parallella sessioner | Ja — men omformulerat efter ditt svar: inte "en gren per repo" utan **en gren per uppgift**, alltid från färsk `main`, synkad mot `main` igen innan merge. Ny skill `branch-per-session`. Cloud-sessioner är redan isolerade (egen container); lokalt i VS Code behövs en worktree per session |
| 4 | Training-coach | `main` skapad från `gallant-bardeen` (inkl. ditt arbete efter analysen: slice 2 klar, dagdetalj + nästa vecka). Den enda commit som bara fanns på `epic-babbage` kommer in via PR #9. Vercel-projekt finns inte än — det skapas på ditt ord |

## 1. Hur det ser ut idag

### Arkitekturen (vad som är byggt)

| Del | Var | Status |
|---|---|---|
| Process + roller | `claude-devteam`-plugin: 6 agenter, 16 kommandon, 5 skills, 1 hook | Fungerar, publik sedan 2026-11-20 |
| Projektregler | Varje projekts `CLAUDE.md` (14–17 KB) | ~6 KB av varje dubblerar pluginet |
| Kvalitetsgrindar (maskin) | Husky pre-push `npm run verify`, PreToolUse-hook lint+typecheck vid commit, CI, living-docs-hook vid `gh pr create` | Bra. Riktiga, inte bara text |
| Kvalitetsgrindar (människa) | Kriterier, design, plan, merge (delvis automatiserat via ship-when-done) | Fyra stopp per feature |
| Review | Opus-reviewer-agent (fresh context) **+** CI-bot (claude-code-action, fem perspektiv) | Dubbelt |
| Designsystem | Alvar som git-dependency | Nytt, ett projekt använder det |
| Minne mellan sessioner | `HANDOFF.md` (snapshot), ROADMAP, Lessons Learned | Fungerar när den skrivs; driver annars |

### Vad som fungerar riktigt bra

- **Artefakter som dispatch-payload.** Det är exakt rätt mönster — samma princip som Anthropics Managed Agents-artikel: tillstånd ska ligga utanför modellen, i en hållbar logg. Dina `features/[name]/`-mappar är det.
- **Maskinella grindar framför textregler.** Hooks som blockerar är värda tio CLAUDE.md-stycken. Living-docs-hooken är ett bra exempel.
- **Reviewer i ren kontext.** Den hittade en riktig blocker i Part A. Den ska vara kvar.
- **Lessons Learned är ärliga.** "Tests prove code works, not that it's wired in" är en verklig insikt som de flesta team aldrig skriver ner.
- **"Omöjligt är en hypotes"** (researcher + spike). Garmin-spiken i training-coach bevisade det.

---

## 2. Spänningar — strukturella vs beteendemässiga

### Strukturella (verktygskedjan skapar dem)

1. **Ingen landningsbana i training-coach.** Ingen `main`, alltså ingen Vercel-produktion, alltså ingen ship-when-done. Kickoff-flödet skapar inte main — det antar att den finns. *Andra ordningens effekt:* varje ny session gör en ny `claude/*`-gren från "något", och arbetet förgrenar sig. Det har redan hänt.
2. **Cloud-sessioner får en ny gren per session.** `claude/youthful-…`, `claude/sleepy-…`, `claude/gallant-…`. I workout-app löses det av att PR:er mergas. I training-coach finns inget att merga till. Ju fler sessioner, desto mer divergens.
3. **Dubbel review.** Opus-reviewer-agenten och CI-boten granskar samma diff. CI-boten kör på din prenumeration (bra beslut 2026-11-20), men det är fortfarande kvot, och två röster som säger olika saker kostar dig uppmärksamhet.
4. **Processtext på tre ställen.** Utvecklingssekvens, teamtabell, kommandotabell och effort-tabell finns i `TEAM.md`/`feature.md` **och** i varje projekts CLAUDE.md. När pluginet ändras (sex versioner på åtta veckor) ljuger projektkopiorna. Det är exakt den drift som pluginet skapades för att stoppa.
5. **Fyra mänskliga grindar för en app med en användare.** Rätt för training-coach (hälsodata, regler från din strategi). Överdimensionerat för en ny övning i workout-app.

### Beteendemässiga (dina mönster, som processen förstärker eller dämpar)

1. **Du startar parallella sessioner.** Det är din styrka (energi, riktning) — men utan en "en aktiv gren per repo"-regel blir det förgrenat arbete.
2. **Beslut parkeras i HANDOFF.** "Waiting on Håkan: low-readiness swap rule" — står kvar. Din egen Lessons Learned säger redan: ett uppskjutet beslut behöver en aktiv knuff. Processen har ingen.
3. **Grindarna gör dig till flaskhals på fel ställen.** Du godkänner mockups (bra, det är där din smak behövs) och planer (sällan där ditt omdöme tillför mest — det är arkitektur, och den är redan lead-agentens ansvar).

---

## 3. Tokenkostnad

Jag kan inte se dina faktiska förbrukningssiffror från den här sessionen — det här är strukturanalys av vad som laddas. Mät med `/cost` och `/context` i en dev-session för att verifiera.

### Var tokens går idag

| Post | Ungefär | Varje tur? | Kommentar |
|---|---|---|---|
| CLAUDE.md när flera repos är anslutna | ~52 KB ≈ 13k tokens | Ja (cachat) | I den här sessionen laddas vault-CLAUDE.md (21 KB) i en dev-analys. Irrelevant för kod |
| Dubblerad processtext i projekt-CLAUDE.md | ~6 KB ≈ 1,5k/projekt | Ja | Ren dubblering av pluginet |
| Skill-listan (sales, legal, marketing, brand-voice, slack…) | ~100+ skills, uppskattningsvis 5–8k tokens | Ja | Ingen av dem används i dev |
| MCP-verktygslistor (Vercel ~300 verktyg, Gmail, Slack…) | Deferred, men namnen listas | Ja | Mindre, men inte noll |
| Subagent-kallstart | 20–60k per dispatch (web-fetch-agenten här: 54k) | Per dispatch | Varje agent läser om CLAUDE.md + artefakter |
| Full `/feature` | Lead + designer + builder (+ fixrundor) + opus-reviewer (+ om-review) + doc-keeper + CI-bot | Per feature | Reviewern på opus och CI-boten är de dyraste "extra" stegen |

### Förbättringar, i ordning efter effekt/insats

1. **En repo per dev-session.** Anslut bara det repo du bygger i. Tar bort vault-CLAUDE.md och de andra projektens regler. Störst effekt, noll kod.
2. **Stäng av sälj/juridik/marknad/brand-voice-plugins i dev-repos** via `enabledPlugins: { "...": false }` i projektets `.claude/settings.json`. Bara i dev — de behövs i vaulten.
3. **Banta projekt-CLAUDE.md till projektspecifikt** (stack, layer-regler, designregler, lessons). Ersätt processtexten med en rad: "Process: `/devteam:feature`, regler i pluginets TEAM.md." ~40 % mindre per projekt, och ingen drift.
4. **En review, inte två.** Antingen opus-reviewer-agenten i sessionen *eller* CI-boten. Se beslut 2.
5. **Storleksstyrd process** (se beslut 1) — färre dispatches på medium-arbete är den största besparingen per feature.
6. **Prompt-cachning sköts redan av Claude Code.** Det som bryter cachen är att ändra CLAUDE.md mitt i en session — gör regeländringar i början eller slutet.

Haiku för test-writer/doc-keeper och sonnet för builder/designer är rätt nivåer. Ändra inte dem.

---

## 4. Agenterna — idag och framåt

**Idag:** en lead som orkestrerar, specialister som dispatchas i sekvens. Det används faktiskt (workout-app Part A/B körde builder + reviewer). I training-coach finns review-notes men inga builder-rapporter i `features/`, så det ser ut som att lead skrev mycket av koden själv på large-arbete — mot regel 1. Kan vara rimligt i en kickoff, men det är värt att veta om det var ett val.

**Vad som saknas, och vad inspirationen pekar på:**

| Idé | Källa | Vad det betyder för dig | Rekommendation |
|---|---|---|---|
| **Tracer-bullet-tickets** — bryt spec i vertikala skivor med beroenden | Pocock `/to-tickets` | Du gör redan "slices" i training-coach. Gör det explicit i `plan.md`: varje skiva mergas för sig | **Ta in** — det är svaret på landningsproblemet |
| **Två-axlig review** (Standards vs Spec, parallella subagenter) | Pocock `/code-review` | Din reviewer gör båda i ett. Delad blir den skarpare | Senare — först en review istället för två |
| **Ubiquitous language / GLOSSARY** | Pocock `/grill-with-docs` | Du har `DOMAIN_MODEL.md`. Det är samma sak. Bra redan | Behåll |
| **`/improve-codebase-architecture`** var några dagar | Pocock | Skulle ha fångat session.ts-dödkoden månader tidigare | **Ta in** som schemalagd uppgift |
| **Loop engineering** — vad startar, vad är framgång, vad sparas, vad händer vid stopp | Threads-post | Builderns finish-loop har redan alla fyra (inklusive "stoppa och rapportera på runda 10"). *Rättelse: första versionen av analysen sa att stoppregeln saknades — den finns.* | Redan på plats |
| **Stateless harness, hållbar logg** | Anthropic Managed Agents | Bekräftar din artefaktdesign. Säger också: lita inte på containern — pusha tidigt | Redan rätt riktning |
| **"Tänk som en expert, hur verifierar du"-prompten** | Rieseberg via Threads | Grilling-skillen gör delvis detta. Verifieringsfrågan saknas i Phase 2 | Lägg till en fråga i grilling |
| **Design-skills** (Impeccable, UI UX Pro Max, tasteskill) | Threads | Du har Alvar, som är *din* smak. En generisk taste-skill konkurrerar med den | Testa **Impeccable** som granskningsverktyg för designer-mockups, inte som källa. Skanna med skillspector först |
| **Superpowers** (obra) | Threads | Dina debugging/verification-skills kommer därifrån redan (THIRD_PARTY_NOTICES) | Inget nytt |

Det du *inte* ska ta in: ett större ramverk (BMAD, Spec-Kit, Pococks hela pipeline). Pococks egen poäng är små, komponerbara skills — inte en process som äger dig. Du har redan en process. Det som saknas är landning, inte fler faser.

---

## 5. Besluten du måste ta

Fyra. De första två är strukturella och låser upp resten.

### Beslut 1 — Hur många mänskliga grindar per storlek?

| Alternativ | Vad det innebär | Vilka dörrar det öppnar |
|---|---|---|
| **A. Två grindar för medium** (rekommenderas): kriterier+mockup i ett godkännande, sedan merge sker automatiskt via ship-when-done. Planen blir lead-ansvar, du ser den men den stoppar inte. Large behåller alla fyra | Halverar dina stopp på det mesta arbetet. Du godkänner där din smak behövs (vad, hur det ser ut) | Öppnar för att låta agenter ta medium-features från ROADMAP utan dig i loopen mellan godkännande och merge |
| B. Behåll fyra överallt | Max kontroll, max väntan | Inget nytt |
| C. En grind (bara merge) | Snabbast, men du förlorar designsmaken tidigt | Risk att du granskar färdiga saker du inte ville ha |

### Beslut 2 — En review eller två?

| Alternativ | Konsekvens |
|---|---|
| **A. Reviewer-agenten i sessionen, CI-boten bort** (rekommenderas) | Reviewern ser screenshots, kör tester, har artefakterna. CI-boten ser bara diffen. Den agenten är bättre |
| B. CI-boten kvar, agenten bort | Billigare i sessionen, sämre review (ingen visuell koll, inga kriterier) |
| C. CI-boten bara på PR:er som *inte* gått genom `/feature` (Dependabot-undantaget finns redan; manuella fixar) | Ett skyddsnät för småfixar. Rimlig kompromiss |

### Beslut 3 — En aktiv gren per repo?

Regel: *en* pågående gren per repo åt gången; ny session fortsätter på den (HANDOFF säger vilken) eller mergar först. Det är en beteenderegel du måste vilja — jag kan bara hålla den om du säger ja. Utan den kommer training-coach-förgreningen att upprepas.

### Beslut 4 — Training-coach: hur landar vi?

`epic-babbage` (14 commits) och `gallant-bardeen` (50 commits) har glidit isär. Valet är vilken som är sanning. Mitt förslag: `gallant-bardeen` blir `main` (den innehåller slice 1, engine v2, mina-pass, slice 2), sedan granskar jag vad som bara finns på `epic-babbage` (verkar vara docs: workout-app-prompt, mockup, research) och plockar in det som saknas. Vercel kopplas till main. Det kräver ditt ja eftersom det sätter produktion.

Plus de två regelfrågorna i training-coach HANDOFF (low-readiness swap rule; rule 3) — de har väntat sedan 2026-11-19.

---

## 6. Vad jag kan ta åt dig

**Utan att fråga, när beslut 1–3 är tagna:**
- Banta CLAUDE.md i båda projekten, flytta processtext till pluginet
- Lägga `enabledPlugins: false` för icke-dev-plugins i dev-repos
- Lägga in verifieringsfrågan i grilling
- Lägga till tracer-bullet-skivor i `plan.md`-formatet
- Skriva handoff, uppdatera ROADMAP, köra doc-keeper — redan regel, men jag gör det konsekvent
- Dependabot och säkerhetspatchar (redan automatiserat)

**Som schemalagd uppgift (en gång i veckan, ny session):**
- Arkitekturhälsa per repo: döda moduler, lagerbrott, docs som ljuger mot koden → en kort rapport
- "Beslut som väntar": skanna HANDOFF/ROADMAP efter "waiting on Håkan" äldre än 7 dagar och lyft dem till dig — det är den aktiva knuffen din Lessons Learned efterlyser

**Det som stannar hos dig:**
- Vad som ska byggas och varför (problem, för vem)
- Mockup-godkännande (din smak)
- Allt som rör produktion första gången, pengar, åtkomst, hälsodata
- Regeländringar i din träningsstrategi

---

## 7. Plan

**Det committade nästa steget (en session, ~1 h):**
1. Du tar beslut 1–4 (svara kort i chatten räcker).
2. Jag landar training-coach (main + merge av grenarna + Vercel-koppling efter ditt ja).
3. Jag släpper devteam v1.7.0: storleksstyrda grindar, en review, en-gren-regel, tracer-bullets i plan-formatet.
4. Jag bantar CLAUDE.md i workout-app och training-coach och stänger av icke-dev-plugins där.

**Mät efteråt (vecka 48–49):** kör `/context` i början av en dev-session före och efter steg 4. Räkna mänskliga stopp per feature. Räkna öppna `claude/*`-grenar per repo (mål: max en).

**Dörrar som öppnas — loggas, öppnas inte nu:**
- Veckovis arkitekturhälsa som schemalagd uppgift
- Två-axlig parallell review (Standards/Spec)
- Impeccable som designgranskare för mockups
- Plugin-evals (`claude plugin eval`) för `/feature` — redan i devteam LATER
- Agenter som plockar medium-features från ROADMAP NOW på egen hand (kräver beslut 1A och att landningen fungerar först)

## Changelog
- 2026-11-22: Beslut 1–4 tagna och genomförda (devteam v1.7.0); rättelse om builderns stoppregel.
- 2026-11-22: Skapad — processanalys med fyra beslut och plan.
