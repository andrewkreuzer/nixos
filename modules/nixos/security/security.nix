{ lib, config, ... }:
{
  security = {
    pam.services.doas = {
      logFailures = true;
      rules.auth.fprintd.enable = lib.mkForce false;
    };
    pam.services.hyprlock = {
      logFailures = true;
      rules.auth.unix.control = lib.mkForce "required";
      rules.auth.fprintd.order = config.security.pam.services.hyprlock.rules.auth.unix.order + 10;
    };
    pam.services.greetd = {
      logFailures = true;
      rules.auth.unix.control = lib.mkForce "required";
      rules.auth.fprintd.order = config.security.pam.services.hyprlock.rules.auth.unix.order + 10;
    };
    # pam.services.except = {
    #   logFailures = true;
    #   unixAuth = false;
    #   fprintAuth = false;
    #   rules.auth.unix.control = lib.mkForce "required";
    #   rules.auth.fprintd.order = config.security.pam.services.except.rules.auth.unix.order + 10;
    #   rules.auth.except = {
    #     control = lib.mkForce "sufficient";
    #     order = config.security.pam.services.except.rules.auth.fprintd.order + 10;
    #     modulePath = "/nix/store/cbvxqlpq2y4vbzg6vdfhfarp1gspnzm3-except-pam-module/lib/libpam_module.so";
    #     settings = {
    #       debug = true;
    #     };
    #   };
    # };
    # pam.services.swaylock = {};
  };
}
