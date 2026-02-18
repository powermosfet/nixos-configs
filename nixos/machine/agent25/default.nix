{ pkgs, ... }:

{
  imports = [
    ../../module/ddclient
    ../../user/asmund
    ../../module/avahi
    ../../module/garbage-collection
    ../../module/auto-update
    ../../module/monitoring/prometheus
    ../../module/monitoring/prometheus/remote-access
    ../../module/tailscale
  ];

  time.timeZone = "Europe/Oslo";

  networking.hostName = "agent25";

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.borgbackup.repos = {
    "main-mook" = {
      authorizedKeysAppendOnly = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmhuYssWYdPft49Cy5PXaYuy9sYU9E3TyyS/icWheXxctKajAypbKrsC6e3FfY8qfT+XgP17hMmpC6/IxpYTK7I39e4GfiBEoMU/YFcO4aPeQV6a7HQIRkXXKuhFRExbbWOhPBfzQ8jX26UzSXj+Xwq2hm42kE873Npe3Gi5P7kk7Z/RTShEWvmpp5JVE/mVL3M4kmzwEdm1TU4zra3iCAtFJ+gzIN7d6Utg99AgvtGhTvl0z5wLZzkuknsUnjNRIIeuhLBT+7VwRwOffJYD8gd8IM8CmTU/qmJosDZN6OrUmA8s9KeCLg4NpUODlZNijYErPHpXLGZJndMwzXhtSJNvrp04fnGVKAFtBzLpNyyr4Sp76LAIInR6ING8N/sD9GuHhmNKMh3ofXsXcR8a8CnNX5RoqnbfqKSkKJw8sf5fQOUyr7OqTHuj16OYJp+h72IN+szTgcxhKkd6c4wIbNmU8lrcU2Lbljvsl6FOuZkIHruax/gTzPMuKUhPZgzdE= asmund@mook"
      ];
    };
  };
  services.borgbackup.repos = {
    "main-zook" = {
      authorizedKeysAppendOnly = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCBS8ZkuggL0+Yx83yyFz3gSiQ48np8DaeWVDmrKlS7Q5yv3FQmk83Zgfszk6vxU4a6wUAVrDXWqAnPd0rON5WuHp/v8PB/dkPvi72/dSQwdN1Ox3CeH53ZiECEc6jFpL67MrpuS7vjy8T8P+SH4cDRYrxmgzbpF5idfjBoYjveZVSt6iyqyzWIPHTAC2xmWN32PWBfvN+5AkWr9kGl/kKE9CxlAFLhp/R/IPNYIO0CJg2uCORyTOamCHZzSjde4MshF8ebGU08zXT49NfkbEarWiZLHO3TDLT1BQEzCGyc5h3WDqDMCtrexpHPjxRKV7XqC2odM+W1GeyGblX7iJn2uuXCkc+HON0tm69NLY2+dnzHS/CJsNcL9Uo5xj/O/GvJWGTwyGlcb3XceQP+pIcb4HE//PzJlkeUjF76BcgtY464AaDQWAgPWzw1Vk+xXL4h1NR41p8NMcSzrPI3QNSodgBIwuab5gxZBvOnEi9jljPngKI1+CLKRnCYeSb7dFUJuqPjK/wj+Ng2uBSbTq/yTSGuPSNiTVM74FhtmNzBs0xNJA2TBgJ26Xb9VxILYg3xN9M/B7SqqUU75ctjXdtGlDCiRp4WsyeUjN+o+o1nPL/ezRjYEV30koG2cpWFjnZgfGbAO6CPRmoT7gTq/2YrA0/dCc2RE7EGA9QowTYaQ== root@zook"
      ];
    };
  };
}
