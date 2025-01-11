{ lib, ... }:
{
  # disable gnomes use of power profile for tlp
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      SOUND_POWER_SAVE_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_MAX_PERF_ON_BAT = 30;
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
}
