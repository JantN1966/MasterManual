import re

input_file = "ManualHPBLUP_3.md"
output_file = "manual_cleaned.md"

with open(input_file, "r", encoding="utf-8") as f:
    text = f.read()

# 1. Remove LaTeX page breaks
text = text.replace("\\newpage", "")

# 2. Remove Table of Contents block
text = re.sub(
    r"## Table of Contents.*?(?=^##\s)",
    "",
    text,
    flags=re.DOTALL | re.MULTILINE
)

# 3. Remove "Back to Table of Contents"
text = re.sub(
    r"\[Back to Table of Contents\]\(#Tabl01\)",
    "",
    text
)

# 4. Convert "\" → HTML line break (your key requirement)
text = re.sub(r"\\\s*$", "<br>", text, flags=re.MULTILINE)

# 5. Remove standalone "\" lines
text = re.sub(r"^\s*\\\s*$", "", text, flags=re.MULTILINE)

# 6. Remove accidental double backslashes
text = text.replace("\\\\", "")

# 7. Clean excessive blank lines (keep structure tight)
text = re.sub(r"\n{3,}", "\n\n", text)

with open(output_file, "w", encoding="utf-8") as f:
    f.write(text)

print("Cleaned Markdown written to:", output_file)