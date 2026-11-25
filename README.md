# Agent system kit

[Türkçe](#türkçe)

One setup for every coding agent you use. Switch between Claude Code, Codex, Gemini CLI or anything else without re-teaching your rules, re-installing your skills, or losing what the agent knows about you and your projects.

Everything here is plain text files and Git. Nothing belongs to one agent.

## What it sets up

| Part | What you get |
| --- | --- |
| **Rules** | The same personal rules in every agent's global instruction file. Tell one agent a rule, all of them know it. Your existing rules are merged, never reworded. If you also install Skills, a copy of the rules is kept in that repo. |
| **Skills** | One Git repo of skills in `~/.agents/skills`, linked into every agent's skills folder. Skills you already keep in an agent's own folder can be moved in during setup, if you agree. Project-specific skills live in each project under `docs/skills/`. |
| **Memory** | A personal vault of linked notes, in a folder you choose, that any agent can read and that changes only when you say so. The `recall-memory` skill that reads it is installed together with it. |
| **Project memory** | The `project-docs-setup` skill, installed into your shared skills folder. In any project you later say "set up the project docs" and it gives that project its own memory (`AGENTS.md`, `docs/PROJECT_MAP.md`, `docs/map/`). |

You choose which parts to install, in any combination. The ready-made skills that belong to a part are installed with it, with no extra question.

## How to use it

1. Clone this repository anywhere on your computer.
2. Open any coding agent in that folder and say:

   > Read SKILL.md in this folder and set up the agent system for me.

3. Answer its questions. There are few: at most five in a normal run (which parts, whether to move your existing skills, where to put the vault, and whether to create and push the two online repos), plus a question only when something unusual comes up. One yes to a repo question covers every commit and push of that setup run. Everything else uses sensible defaults, which the agent lists at the end.

The skills and the vault are backed up in online Git repos, always private. If you use GitHub, you sign in yourself from this computer and the agent creates the repos for you. With another Git host, you create the repos there and give the agent their addresses.

On a second computer, download the kit again and use it the same way. The agent notices that your repos already exist and clones them instead of creating new ones, and it does not ask again for the choices you made the first time. Your rules come along too: the agent starts from the copy kept in your skills repo.

Works on macOS and Linux. On Windows, use WSL.

The setup files are in English, but the agent talks to you in your own language. Your notes are written in the language you use with the agent; only the structural files stay in English.

## What is inside

```text
SKILL.md                      the setup skill: asks what you want, then installs it
LICENSE                       MIT License
modules/
  rules/SETUP.md              shared rules
  skills/SETUP.md             shared skills
  skills/githooks/            link script and Git hooks copied into your skills repo
  memory/SETUP.md             personal vault and project memory
  memory/vault-template/      empty vault: rules, folder layout, note templates
bundled-skills/
  project-docs-setup/         gives a project its own memory
  recall-memory/              reads your vault before answering
```

## Before you start

- Read the module files if you want to know exactly what will happen. They are short.
- Do not hand your computer over blindly. The agent stops and asks before it touches an existing file with unrelated content, and it pushes only after your yes to the repo question; read what it asks.
- The memory vault will hold personal information. Keep its Git repo private.

## License

MIT License. See [LICENSE](LICENSE).

---

## Türkçe

Kullandığın bütün coding agent'lar için tek kurulum. Claude Code, Codex, Gemini CLI ya da başka bir agent arasında geçiş yaparken kurallarını yeniden anlatmazsın, skill'lerini yeniden kurmazsın, agent'ın senin ve projelerin hakkında bildiklerini de kaybetmezsin.

Buradaki her şey düz metin dosyası ve Git. Hiçbiri tek bir agent'a ait değil.

### Ne kuruyor

| Parça | Ne kazanırsın |
| --- | --- |
| **Rule'lar** | Her agent'ın global talimat dosyasında aynı kişisel kurallar. Bir agent'a kural söylersin, hepsi bilir. Mevcut kuralların birleştirilir, ifadeleri asla değiştirilmez. Skill'leri de kurarsan kuralların bir kopyası o repoda tutulur. |
| **Skill'ler** | `~/.agents/skills` altında tek bir Git reposu, her agent'ın skill klasörüne linklenir. Bir agent'ın kendi klasöründe zaten duran skill'ler, onay verirsen kurulum sırasında buraya taşınır. Projeye özel skill'ler o projenin `docs/skills/` klasöründe durur. |
| **Hafıza** | Seçtiğin bir klasörde duran, her agent'ın okuyabildiği, yalnızca sen söylediğinde değişen, birbirine bağlı notlardan oluşan kişisel bir vault. Onu okuyan `recall-memory` skill'i de birlikte kurulur. |
| **Proje hafızası** | Ortak skill klasörüne kurulan `project-docs-setup` skill'i. Sonra herhangi bir projede "proje dokümanlarını kur" dersin, o projeye kendi hafızasını verir (`AGENTS.md`, `docs/PROJECT_MAP.md`, `docs/map/`). |

Hangi parçaları kuracağını istediğin birleşimle sen seçersin. Bir parçaya ait hazır skill'ler, ekstra soru sorulmadan o parçayla birlikte kurulur.

### Nasıl kullanılır

1. Bu repoyu bilgisayarında istediğin bir yere klonla.
2. O klasörde herhangi bir coding agent aç ve şunu söyle:

   > Bu klasördeki SKILL.md dosyasını oku ve agent sistemini benim için kur.

3. Sorularını yanıtla. Az sorar: normal bir kurulumda en fazla beş soru (hangi parçalar, mevcut skill'lerin taşınıp taşınmayacağı, vault'un nereye konacağı, iki online reponun oluşturulup push edilip edilmeyeceği), yalnızca olağan dışı bir durum çıkarsa ek soru. Bir repo sorusuna verdiğin tek evet, o kurulumdaki bütün commit ve push'ları kapsar. Geri kalan her şey makul varsayılanlarla yapılır ve agent bunları sonunda sana listeler.

Skill'lerin ve vault'un yedeği online Git repolarında durur ve repolar her zaman gizlidir (private). GitHub kullanıyorsan girişi bu bilgisayardan sen kendin yaparsın, repoları agent oluşturur. Başka bir Git servisi kullanıyorsan repoları orada sen oluşturur, adreslerini agent'a verirsin.

İkinci bir bilgisayarda kiti yeniden indirip aynı şekilde kullanırsın. Agent repolarının zaten var olduğunu görür, yenisini oluşturmak yerine onları klonlar ve ilk seferde yaptığın seçimleri yeniden sormaz. Kuralların da seninle gelir: agent, skill reponda tutulan kopyadan başlar.

macOS ve Linux'ta çalışır. Windows'ta WSL gerekir.

Kurulum dosyaları İngilizce, ama agent seninle kendi dilinde konuşur. Notların, agent'la konuştuğun dilde yazılır; yalnızca yapıyı belirleyen dosyalar İngilizce kalır.

### İçinde ne var

```text
SKILL.md                      kurulum skill'i: ne istediğini sorar, sonra kurar
LICENSE                       MIT lisansı
modules/
  rules/SETUP.md              ortak rule'lar
  skills/SETUP.md             ortak skill'ler
  skills/githooks/            skill repona kopyalanan link script'i ve Git hook'ları
  memory/SETUP.md             kişisel vault ve proje hafızası
  memory/vault-template/      boş vault: kurallar, klasör düzeni, not şablonları
bundled-skills/
  project-docs-setup/         bir projeye kendi hafızasını verir
  recall-memory/              cevap vermeden önce vault'unu okur
```

### Başlamadan önce

- Tam olarak ne olacağını bilmek istersen modül dosyalarını oku. Kısalar.
- Bilgisayarını agent'a körü körüne teslim etme. İçeriği başka olan bir dosyaya dokunmadan önce durup sana sorar, push'u da yalnızca repo sorusuna verdiğin evetten sonra yapar; ne sorduğunu oku.
- Hafıza vault'unda kişisel bilgilerin olacak. Git reposunu gizli (private) tut.

### Lisans

MIT lisansı. Ayrıntılar için [LICENSE](LICENSE) dosyasına bak.
