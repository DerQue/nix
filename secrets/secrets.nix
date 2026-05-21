let
  # Run: cat /etc/ssh/ssh_host_ed25519_key.pub
  gaming = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOM8p4m9M7sYrbQ/FpmKNoYe/wPSoZ+oZOjX9ZaWMeKN";

  # Run on macbook: cat /etc/ssh/ssh_host_ed25519_key.pub
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjAw4WVau4XJXzYNyPn/bHz3ptojUo+Mxr2Ytw+EvVX";

  # Your personal SSH key (for encrypting from any machine)
  # Run: cat ~/.ssh/id_ed25519.pub
  quentin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrs3v1+/TF5p/8Ezbj5jbpbZghNO1SKUWhkzd2gmxoD me@quentin-schuster.de";

  allKeys = [ gaming macbook quentin ];
in
{
  "gaming-password.age".publicKeys = [ gaming quentin ];
  "macbook-wireguard.age".publicKeys = [ macbook quentin ];
}
