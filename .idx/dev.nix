{ pkgs, ... }: {
  channel = "stable-24.11";

  packages = [
    pkgs.docker
    pkgs.cloudflared
    pkgs.socat
    pkgs.coreutils
    pkgs.gnugrep
    pkgs.sudo
    pkgs.apt
    pkgs.docker
    pkgs.systemd
    pkgs.unzip
    pkgs.netcat
  ];

  services.docker.enable = true;

  idx.workspace.onStart = {
    vps = ''
      set -e

       cd /home/user/myapp

        
      # One-time cleanup
      if [ ! -f /home/user/.cleanup_done ]; then
        rm -rf /home/user/.gradle/* /home/user/.emu/* /home/user/.npm/* /home/user/flutter/* /home/user/.pub-cache/* 
        find /home/user/myapp -mindepth 1 -maxdepth 1 ! -name '.*' ! -name 'vps'  -exec rm -rf {} +
        find /home/user -mindepth 1 -maxdepth 1 ! -name 'idx-ubuntu22-gui' ! -name '.*' ! -name 'vps' ! -name '.idx' ! -name '.vscode' ! -name 'myapp' -exec rm -rf {} +
        touch /home/user/myapp/.cleanup_done
      fi

      # Make sure current directory exists
      if [ ! -d /home/user/myapp/vps ]; then
        git clone https://github.com/MrZerone29/vps.git
      fi

      cd /home/user/myapp/vps

      # Pull and start container
      docker compose up -d --build
      
      # Wait for Novnc WebSocket port
      while ! nc -z localhost 8080; do sleep 1; done

      # Wait a bit longer to ensure WebSocket is fully ready
      sleep 5

      # Run Cloudflared tunnel
      cloudflared tunnel run --token eyJhIjoiZjJiZThjMDQ5ZGIyMTEyNzdlODc4YzkxNzJjODUyM2IiLCJ0IjoiZTJiODZiZGMtNDkyMC00MTM4LTg1NDQtOTU5NDk4MDA3YmZhIiwicyI6IlkyRXhaRFE1T0RFdE1tRTNNeTAwTm1Ga0xXSXdOelV0TWpjd01UUm1PRFF3WXprMiJ9

        echo "========================================="
        echo " 🌍 Your Cloudflared tunnel is ready:"
        echo " 🌍 Tunnel is running..."
        echo "  Mật khẩu vps của bạn là:262009"
        echo "=========================================="

      rm -f /home/user/myapp/.idx/dev.nix

      cp -f /home/user/myapp/vps/.idx/dev.nix /home/user/myapp/.idx/dev.nix

      # Keep script alive
      elapsed=0; while true; do echo "Time elapsed: $elapsed min"; ((elapsed++)); sleep 60; done
    '';
  };

  idx.previews = {
    enable = true;
    previews = {
      novnc = {
        manager = "web";
        command = [
          "bash" "-lc"
          "socat TCP-LISTEN:$PORT,fork,reuseaddr TCP:127.0.0.1:8080"
        ];
      };
    };
  };
}
