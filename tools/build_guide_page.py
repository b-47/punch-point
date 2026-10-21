"""Build concepts/test-rig/build-guide.html from build-guide.md, so GitHub Pages serves the
guide as a web page (the site has .nojekyll, so Markdown files are not rendered).
Run it after every edit to build-guide.md: python3 tools/build_guide_page.py"""
import re
from pathlib import Path
import markdown

RIG = Path(__file__).resolve().parent.parent / "concepts" / "test-rig"
src = (RIG / "build-guide.md").read_text()
# Python-Markdown is stricter than GitHub: nested items need 4 spaces of indent, and a list
# needs a blank line before it when it follows a paragraph line
lines = []
for ln in src.splitlines():
    m = re.match(r"^( {1,3})([-*] |\d+\. )", ln)
    if m:
        ln = "    " + ln[len(m.group(1)):]
    starts_list = re.match(r"^([-*] |\d+\. )", ln)
    if starts_list and lines and lines[-1].strip() and not re.match(r"^(\s*[-*] |\s*\d+\. |\|)", lines[-1]):
        lines.append("")
    lines.append(ln)
src = "\n".join(lines) + "\n"
body = markdown.markdown(src, extensions=["tables", "sane_lists"])
# links to other Markdown files point at their GitHub pages, which render them
body = re.sub(r'href="(?!https?:)([^"#]+\.md)(#[^"]*)?"',
              lambda m: f'href="https://github.com/b-47/punch-point/blob/main/concepts/test-rig/{m.group(1)}{m.group(2) or ""}"', body)
body = re.sub(r'href="(?!https?:)((?:print|firmware|cad)/[^"]*)"',
              lambda m: f'href="https://github.com/b-47/punch-point/tree/main/concepts/test-rig/{m.group(1)}"', body)
page = f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Build the punch test rig</title>
<style>
:root {{ --bg: #ffffff; --fg: #1d1d1f; --muted: #5a5a60; --line: #d9d9de; --code: #f2f2f5; --link: #0b57d0; }}
@media (prefers-color-scheme: dark) {{
  :root {{ --bg: #141416; --fg: #ececf0; --muted: #a8a8b0; --line: #34343a; --code: #232328; --link: #8ab4f8; }}
}}
body {{ margin: 0; background: var(--bg); color: var(--fg); font: 17px/1.55 system-ui, -apple-system, "Segoe UI", sans-serif; }}
main {{ max-width: 46rem; margin: 0 auto; padding: 1.5rem 16px 4rem; }}
h1 {{ font-size: 1.9rem; line-height: 1.2; }}
h2 {{ font-size: 1.35rem; margin-top: 2.4rem; padding-top: 0.6rem; border-top: 1px solid var(--line); }}
h3 {{ font-size: 1.1rem; margin-top: 1.6rem; }}
li {{ margin: 0.25rem 0; }}
img {{ display: block; max-width: 100%; max-height: 24rem; width: auto; height: auto; border: 1px solid var(--line); border-radius: 6px; }}
table {{ border-collapse: collapse; width: 100%; display: block; overflow-x: auto; }}
th, td {{ border: 1px solid var(--line); padding: 0.4rem 0.6rem; text-align: left; vertical-align: top; }}
code {{ background: var(--code); padding: 0.1rem 0.3rem; border-radius: 4px; font-size: 0.92em; }}
a {{ color: var(--link); }}
</style>
</head>
<body>
<main>
{body}
</main>
</body>
</html>
"""
(RIG / "build-guide.html").write_text(page)
print("wrote", RIG / "build-guide.html")
