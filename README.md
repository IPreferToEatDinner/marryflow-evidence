# marryflow — Development Evidence Transcript

A **metadata-only** record of the development history of the MarryFlow wedding
planning product. Published to support a takedown request concerning
`marryflow.love`, which is hosted on Manus.

This repository contains **no source code, no file contents, and no secrets.**

---

## 1. What this repository is for

The operator of `marryflow.cn` has asked Manus to act against `marryflow.love`
on grounds of brand impersonation and copyright infringement. Manus requested
evidence of original authorship dated before March 2026, and evidence that the
complainant operates `marryflow.cn`.

The underlying repositories are private, because they contain commercial source
code. This repository publishes the parts that can be disclosed without
revealing that code: commit hashes, timestamps, commit subjects, and per-commit
change statistics (file paths and line counts only).

**This repository is a convenience transcript, not the primary evidence.** The
primary evidence is the private repository itself, which can be inspected
through a time-limited read-only invitation on request.

## 2. Contents

| File | Description |
|---|---|
| `data/commits-marryflow-web.txt` | Every commit in the web repository: hash, author date, author name, subject |
| `data/changes-marryflow-web.txt` | Per-commit file paths and added/deleted line counts — no file contents |
| `data/commits-per-month.txt` | Commit volume by month |
| `data/all-repositories.txt` | First and last commit of each of the four repositories |
| `data/tags.txt` | Tags (none were created) |
| `data/bundle-sha256.txt` | SHA-256 of a `git bundle` of the web repository |
| `data/summary.txt` | Generation metadata |
| `docs/PRD-2026-01-13.md` | Product requirements document, version 1.0, dated 2026-01-13, first committed 2026-01-14 |
| `verify.txt` | SHA-256 checksum of every file in `data/` |
| `screenshots/commits-list.jpg` | Full commit list as rendered by GitHub; every hash matches `data/commits-marryflow-web.txt` |

## 3. Repository timeline

| Period | Repository | Role |
|---|---|---|
| 2026-01-11 → 2026-03-18 | `marryflow` (web) | **Prior use** — landing site and product demo |
| 2026-03-22 → 2026-04-05 | `marryflow-backend` | Continuity only |
| 2026-03-22 → 2026-04-05 | `marryflow-mobile` | Continuity only |
| 2026-04-05 → present | `marryflow-monorepo` | Continuity only |

The three repositories created after 2026-03-17 establish **continuity of
development only**. They are not offered as evidence of prior use.

The product was developed as three separate repositories and later consolidated
into a monorepo. There is no gap in development: 2026-03-18 → 2026-03-22 is a
three-day interval, and the monorepo begins on the day the backend and mobile
repositories end.

## 4. Key documents

`docs/PRD-2026-01-13.md` is the product requirements document for
"MarryFlow 智能婚礼筹备管理平台". Its header is dated **2026-01-13**, and the file
was first committed on **2026-01-14** (commit `9ac04b3`). It defines the product
name, positioning and feature set — budget, tasks, guests and roles, schedule
and milestones, vendor management — two months before `marryflow.love` was
registered.

## 5. How the data was generated

Run inside a clone of the private repository:

```bash
git log --reverse --date=iso-strict \
  --pretty=format:'%H|%ad|%an|%s' > commits.txt

git log --reverse --date=short --numstat \
  --pretty=format:'--- %H | %ad | %s' > changes.txt

git log --date=format:'%Y-%m' --pretty=format:'%ad' \
  | sort | uniq -c > commits-per-month.txt

git bundle create marryflow-web.bundle --all
shasum -a 256 marryflow-web.bundle
```

The script `generate.sh` reproduces the whole set.

## 6. Integrity

The `git bundle` of the private repository is **not published here**, because it
contains the full source code. It is retained, and its SHA-256 is recorded in
`data/bundle-sha256.txt`. The bundle can be provided to Manus, to a court, or to
a court-appointed expert on request, and its checksum allows verification that
it has not been altered.

`verify.txt` records the checksum of each published data file.

The commit hashes visible in `screenshots/commits-list.jpg` can be matched
one-to-one against `data/commits-marryflow-web.txt`, so the screenshot and the
transcript corroborate each other.

## 7. Scope and limitations

- Commit timestamps in Git are supplied by the author, and are therefore not
  cryptographic proof of when work happened. In all four repositories, however,
  author and committer timestamps are identical for every commit, and no rebase,
  amend or history rewrite is evident.
- All commits are authored under the name `asgerzhou`, the account holder's
  regular handle.
- This transcript does not by itself establish authorship. It exists so that the
  reviewer can see the shape of the history without access to the source code,
  and can then request access to the repository itself.

## 8. Related public record

| Date | Record | Where to verify |
|---|---|---|
| 2026-01-11 | Domain `marryflow.cn` registered | WHOIS / registrar certificate |
| 2026-01-22 | ICP filing approved, 浙ICP备2024136790号-6 | beian.miit.gov.cn (public query) |
| 2026-03-17 | Domain `marryflow.love` registered | WHOIS |

## 9. Contact

The operator of `marryflow.cn`, 周思瑞 (Zhou Sirui).

This repository was generated on 2026-10-20.
