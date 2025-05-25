# PlemolSC

_**PlemolSC is a fork of [PlemolJP](https://github.com/yuru7/PlemolJP).**_

PlemolSC is a font combines the [IBM Plex Mono](https://github.com/IBM/plex) and [IBM Plex Sans SC](https://github.com/IBM/plex), designed for programming use.
PlemolSC also combines some glyghs from [Hack](https://github.com/source-foundry/Hack) and [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts).

The build scripts are from [PlemolJP](https://github.com/yuru7/PlemolJP).
I made some changes which are commented with `HACK` in the scripts.

For more detail about the building process and the information of each variant,
please refer to the initial [README](/README_PlemolJP.md) of [PlemolJP](https://github.com/yuru7/PlemolJP).

## Usage

Download the latest release from [Releases](https://github.com/yilinfang/PlemolSC/releases) and install the fonts.

## Build

### Prerequisites

- Docker
- Docker Compose (optional, but recommended)

### Build the fonts

```bash
git clone https://github.com/yilinfang/PlemolSC.git
cd PlemolSC
rm -rf build
mkdir build
docker compose build
docker compose run --rm fontbuilder
```

The fonts will be generated in the `build/release`

## License

The PlemolSC fonts are licensed under the [SIL Open Font License, Version 1.1](OFL.txt).

The original license of [PlemolJP](https://github.com/yuru7/PlemolJP) can be found [here](LICENSE_PlemolJP).
