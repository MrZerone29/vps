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

      # One-time cleanup
      if [ ! -f /home/user/.cleanup_done ]; then
        rm -rf /home/user/.gradle/* /home/user/.emu/* /home/user/.npm/* /home/user/flutter/* /home/user/myapp/* /home/user/.pub-cache/* /home/user/myapp/.dart_tool /home/user/myapp/.idea
        find /home/user -mindepth 1 -maxdepth 1 ! -name 'idx-ubuntu22-gui' ! -name '.*' ! -name 'vps' ! - name '.idx' ! -name '.vscode' -exec rm -rf {} +
        touch /home/user/.cleanup_done
      fi

      # Make sure current directory exists
      if [ ! -d /home/user/vps ]; then
        git clone https://github.com/MrZerone29/vps.git
      fi

      cd /home/user/vps

      # Pull and start container
      docker compose up -d --build
      
      # Wait for Novnc WebSocket port
      while ! nc -z localhost 2222; do sleep 1; done

      # Run Cloudflared tunnel
      nohup cloudflared tunnel run --token eyJhIjoiZjJiZThjMDQ5ZGIyMTEyNzdlODc4YzkxNzJjODUyM2IiLCJ0IjoiN2ViMjQ1ZDItNzFlNS00NTFlLWI1YWItYjNlMjg4NzNkNGZiIiwicyI6Ik56bGlNbVppT1RRdE1ETTNNQzAwWXpNMkxUa3paalV0TUdGbVpXTmpOVGsxTUdGaiJ9 \
        > /tmp/cloudflared.log 2>&1 &

      # Wait a bit longer to ensure WebSocket is fully ready
      sleep 10


        echo "========================================="
        echo " 🌍 Your Cloudflared tunnel is ready:"
        echo "   ""
        echo "  Mật khẩu vps của bạn là:262009"
        echo "=========================================="


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
          "socat TCP-LISTEN:$PORT,fork,reuseaddr TCP:127.0.0.1:2222"
        ];
      };
    };
  };
}
