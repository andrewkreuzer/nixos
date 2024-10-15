{
  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;

      /* rootless = { */
      /*   enable = true; */
      /*   setSocketVariable = true; */
      /* }; */
    };
  };
}
