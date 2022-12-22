{ fetchurl, linkFarmFromDrvs }:
let version = "aa6ac1e23bb9a499be2b7400079cd2a7b8a1309a";
in linkFarmFromDrvs "opt-1.3b" [
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-1.3b/resolve/${version}/merges.txt";
    sha256 = "HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-1.3b/resolve/${version}/config.json";
    sha256 = "8arO77fTTTRumwQA2V/bSXBWe8vh1KuhBoxUAgmbZE8=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-1.3b/resolve/${version}/pytorch_model.bin";
    sha256 = "z31clw1t29OwMAmzl8BCLhR+3VyAINR6jS+sCxGjsI0=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-1.3b/resolve/${version}/tokenizer_config.json";
    sha256 = "0eQYW0OgoGQhq3IY1cGndTUL0TAkUHs0++0l3PbBTGs=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-1.3b/resolve/${version}/vocab.json";
    sha256 = "BrTUbI51LUECE9lUjrJ6VNtw/aAxm2Jx+41Z3q1eHKs=";
  })
]
