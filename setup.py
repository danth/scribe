from setuptools import setup

setup(
    name="scribe",
    version="0.0.0",
    author="Daniel Thwaites",
    author_email="danthwaites30@btinternet.com",
    packages=["scribe"],
    install_requires=[
        "pygobject >=3,<4"
    ],
    entry_points={
        "console_scripts": [ "scribe=scribe.__main__:main" ]
    }
)
