from setuptools import setup, find_packages

setup(
    name='genai_kafka',
    version='1.0',
    author='sdubey',
    author_email='sdubey@confluent.io',
    description='GenAI specific kafka client library',
    packages=find_packages(),  # Automatically find all packages and subpackages
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
)
