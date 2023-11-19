# dotfiles

## System tweaks

### Disable broken xhci device before suspend and avoid freeze

This is a bug that prevent some laptops from suspending successfully or make them become unresponsive after suspending.

This [gist](https://gist.github.com/ioggstream/8f380d398aef989ac455b93b92d42048) was made by [ioggstream](https://github.com/ioggstream).

```bash
#!/bin/sh
#
# This script should prevent the following suspend errors
#  which freezes the Dell Inspiron laptop.
#
# Put it in /usr/lib/systemd/system-sleep/xhci.sh
#
# The PCI 00:14.0 device is the usb xhci controller.
#
#    kernel: [67445.560610] pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -16
#    kernel: [67445.560619] dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -16
#    kernel: [67445.560624] PM: Device 0000:00:14.0 failed to suspend async: error -16
#    kernel: [67445.886961] PM: Some devices failed to suspend, or early wake event detected

if [ "${1}" == "pre" ]; then
  # Do the thing you want before suspend here, e.g.:
  echo "Disable broken xhci module before suspending at $(date)..." > /tmp/systemd_suspend_test
  grep XHC.*enable /proc/acpi/wakeup && echo XHC > /proc/acpi/wakeup
elif [ "${1}" == "post" ]; then
  # Do the thing you want after resume here, e.g.:
  echo "Enable broken xhci module at wakeup from $(date)" >> /tmp/systemd_suspend_test
  grep XHC.*disable /proc/acpi/wakeup && echo XHC > /proc/acpi/wakeup
fi
```

### OOM killer doesn't always work

On many systems, the OOM killer, when triggered, will scan through the entire tasklist and select a task based on heuristics to kill. In practice, the system rarely has enough resources left to perform such scan, leaving the system totally unusable.

Instead, setting `oom_kill_allocating_task` to `1` allows the OOM killer to simply kill the task that triggered the out-of-memory condition.

For one time testing:

```bash
echo 1 | sudo tee /proc/sys/vm/oom_kill_allocating_task
```

To keep the change permanent, write the following to `/etc/sysctl.conf` or to a new file under `/etc/sysctl.d/`:

```bash
vm.oom_kill_allocating_task = 1
```

[Relevant askUbuntu post](https://askubuntu.com/questions/398236/oom-killer-not-working)

Optionally, enable `earlyoom` to terminate tasks early, before OOM is triggered.
