for i in 1 2
do
  echo "************************************************"
  echo "**                  STARTING                  **"
  echo "************************************************"
  sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y
done
