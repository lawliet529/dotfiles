{ pkgs ? import <nixpkgs> {} }:

let

  # Mamba installs it's packages and environments under this directory
  installationPath = "~/mambaforge";

  # Downloaded Mambaforge installer
  mambaforgeScript = pkgs.stdenv.mkDerivation rec {
    name = "mambaforge-${version}";
    version = "23.11.0-0";
    src = pkgs.fetchurl {
      url = "https://github.com/conda-forge/miniforge/releases/download/${version}/Mambaforge-${version}-Linux-x86_64.sh";
      sha256 = "3dfdcc162bf0df83b5025608dc2acdbbc575bd416b75701fb5863343c0517a78";
    };
    # Nothing to unpack.
    unpackPhase = "true";
    # Rename the file so it's easier to use. The file needs to have .sh ending
    # because the installation script does some checks based on that assumption.
    # However, don't add it under $out/bin/ becase we don't really want to use
    # it within our environment. It is called by "mamba-install" defined below.
    installPhase = ''
      mkdir -p $out
      cp $src $out/mambaforge.sh
    '';
    # Add executable mode here after the fixup phase so that no patching will be
    # done by nix because we want to use this mambaforge installer in the FHS
    # user env.
    fixupPhase = ''
      chmod +x $out/mambaforge.sh
    '';
  };

  # Wrap mambaforge installer so that it is non-interactive and installs into the
  # path specified by installationPath
  mamba = pkgs.runCommand "mamba-install"
    { buildInputs = [ pkgs.makeWrapper mambaforgeScript ]; }
    ''
      mkdir -p $out/bin
      makeWrapper                            \
        ${mambaforgeScript}/mambaforge.sh      \
        $out/bin/mamba-install               \
        --add-flags "-p ${installationPath}" \
        --add-flags "-b"
    '';

in
(
  pkgs.buildFHSUserEnv {
    name = "mamba";
    targetPkgs = pkgs: (
      with pkgs; [

        mamba

        # Add here libraries that Mamba packages require but aren't provided by
        # Mamba because it assumes that the system has them.
        #
        # For instance, for IPython, these can be found using:
        # `LD_DEBUG=libs ipython --pylab`
        libGL
        libselinux
        libz
        xorg.libICE
        xorg.libSM
        xorg.libXcursor
        xorg.libXrender

        # Just in case one installs a package with pip instead of mamba and pip
        # needs to compile some C sources
        gcc

        # Add any other packages here, for instance:
        emacs
        git

      ]
    );
    profile = ''
      # Add mamba to PATH
      export PATH=${installationPath}/bin:$PATH
      # Paths for gcc if compiling some C sources with pip
      export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
      export NIX_CFLAGS_LINK="-L${installationPath}lib"
      # Some other required environment variables
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale
    '';
  }
).env
