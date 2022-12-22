{ fetchurl, linkFarmFromDrvs }:
let version = "934b6a077313f3ee660a918a95313f5d0b136c5a";
in linkFarmFromDrvs "opt-125m" [
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-125m/resolve/${version}/merges.txt";
    sha256 = "HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-125m/resolve/${version}/config.json";
    sha256 = "VBYsnNA3cRDfGFnfq+uxBvwJiMiq24ggfOHuDTSYXfY=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-125m/resolve/${version}/pytorch_model.bin";
    sha256 = "LXTaZhUTXFjPPPmtTLEefGE/+eVf5likerg7bI0RdKk=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-125m/resolve/${version}/tokenizer_config.json";
    sha256 = "0eQYW0OgoGQhq3IY1cGndTUL0TAkUHs0++0l3PbBTGs=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-125m/resolve/${version}/vocab.json";
    sha256 = "BrTUbI51LUECE9lUjrJ6VNtw/aAxm2Jx+41Z3q1eHKs=";
  })
]
