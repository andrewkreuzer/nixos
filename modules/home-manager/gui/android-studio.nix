{ pkgs-unstable, ... }:
let
  pkgs = pkgs-unstable;
in
{
  home.packages = with pkgs; [
    (android-studio.withSdk (androidenv.composeAndroidPackages {
      includeNDK = true;
      ndkVersions = [ "27.2.12479018" ];
      platformToolsVersion = "35.0.2";
      buildToolsVersions = [ "35.0.1" ];
      includeEmulator = true;
      emulatorVersion = "35.6.2";
      cmakeVersions = [ "3.31.6" ];
    }).androidsdk)
  ];

  home.file.".ideavimrc" = {
    text = ''
      """ Map leader to space ---------------------
      let mapleader=" "

      """ Plugins  --------------------------------
      set surround
      set multiple-cursors
      set commentary
      set argtextobj
      set easymotion
      set textobj-entire
      set ReplaceWithRegister

      """ Plugin settings -------------------------
      let g:argtextobj_pairs="[:],(:),<:>"

      """ Common settings -------------------------
      set showmode
      set so=5
      set incsearch
      set nu

      """ Idea specific settings ------------------
      set ideajoin
      set ideastatusicon=gray
      set idearefactormode=keep

      """ Mappings --------------------------------
      map <leader>f <Plug>(easymotion-s)
      map <leader>e <Plug>(easymotion-f)

      map <leader>d <Action>(Debug)
      map <leader>rn <Action>(RenameElement)
      map <leader>c <Action>(Stop)
      map <leader>z <Action>(ToggleDistractionFreeMode)

      map <leader>s <Action>(SelectInProjectView)
      map <leader>a <Action>(Annotate)
      map <leader>h <Action>(Vcs.ShowTabbedFileHistory)
      map <S-Space> <Action>(GotoNextError)

      map <leader>b <Action>(ToggleLineBreakpoint)
      map <leader>o <Action>(FileStructurePopup)
    '';
    executable = false;
  };
}
