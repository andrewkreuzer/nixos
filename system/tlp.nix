{ lib, ... }:
{
  # disable gnomes use of power profile for tlp
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = false;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      PLATFORM_PROFILE_ON_AC  = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";

      CPU_MAX_PERF_ON_AC            = 100;
      CPU_MAX_PERF_ON_BAT           = 40;
      CPU_BOOST_ON_AC               = 1;
      CPU_BOOST_ON_BAT              = 0;
      CPU_HWP_DYN_BOOST_ON_AC       = 1;
      CPU_HWP_DYN_BOOST_ON_BAT      = 0;
      CPU_SCALING_GOVERNOR_ON_AC    = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT   = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      DISK_DEVICES = "nvme0n1 nvme1n1";

      RESTORE_DEVICE_STATE_ON_STARTUP = 1;
      WIFI_PWR_ON_BAT                 = "off";
      # DEVICES_TO_DISABLE_ON_DOCK      = "wifi";
      # DEVICES_TO_ENABLE_ON_UNDOCK     = "wifi";

      SOUND_POWER_SAVE_ON_AC = 0;
    };
  };
}
