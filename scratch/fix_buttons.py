import os
import re

lib_path = r'c:\Users\Haram\Desktop\ULVENIK\lib\screens'

def ensure_import(content, file_path):
    import_statement = "import '../widgets/custom_snackbar.dart';"
    if import_statement not in content and 'custom_snackbar.dart' not in content:
        # find the last import and insert after
        imports = re.findall(r'^import .*?;', content, re.MULTILINE)
        if imports:
            last_import = imports[-1]
            content = content.replace(last_import, last_import + '\n' + import_statement, 1)
        else:
            content = import_statement + '\n' + content
    return content

for file in os.listdir(lib_path):
    if not file.endswith('.dart'): continue
    path = os.path.join(lib_path, file)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    # Replace empty onPressed
    content = re.sub(r'onPressed:\s*\(\)\s*\{\s*\}', r"onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info)", content)
    # Replace empty onTap
    content = re.sub(r'onTap:\s*\(\)\s*\{\s*\}', r"onTap: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info)", content)
    
    if content != original:
        content = ensure_import(content, path)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {file}')
