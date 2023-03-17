#!python3
import sys
from os import listdir
from os.path import isfile, join
import yaml

def format(recipe):
    formatted = {
        'name': recipe['name'], 
        'description': recipe['description'],
        'provider': recipe['provider'],
        'primary': recipe['primary']
    }
    for k, v in recipe.items():
        if k not in {'name', 'description', 'provider', 'primary'}:
            formatted[k] = v
    
    return formatted

app = sys.argv[1]
path = f"{app}/plural/recipes"
for f in listdir(path):
  if isfile(join(path, f)):
    filename = join(path, f)
    with open(filename, 'r') as file:
        recipe = yaml.safe_load(file)
        recipe['primary'] = True
    with open(filename, 'w') as file:
        yaml.dump(format(recipe), file, sort_keys=False)
