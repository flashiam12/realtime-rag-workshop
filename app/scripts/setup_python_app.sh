#! /bin/bash 

python3 -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt

cd app
python setup.py sdist bdist_wheel

cp runners/* build/lib/

