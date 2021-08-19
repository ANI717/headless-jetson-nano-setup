cd ~
sudo apt update

sudo apt install -y python3-pip curl libffi-dev
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
python3 -m pip install setuptools cffi git+https://github.com/ipython/traitlets@4.x jupyter jupyterlab

export PATH=$PATH:~/.local/bin
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install @jupyterlab/statusbar
jupyter lab --generate-config
python3 -c "from jupyter_server.auth.security import set_password; set_password('jetbot', '$HOME/.jupyter/jupyter_server_config.json')"

echo "c.NotebookApp.token = ''" >> $HOME/.jupyter/jupyter_lab_config.py
echo "c.NotebookApp.password_required = True" >> $HOME/.jupyter/jupyter_lab_config.py
echo "c.NotebookApp.allow_credentials = False" >> $HOME/.jupyter/jupyter_lab_config.py

git clone https://github.com/ANI717/headless_jetson_nano_setup
cd ./headless_jetson_nano_setup
python3 create_jupyter_service.py
sudo mv jetbot_jupyter.service /etc/systemd/system/jetbot_jupyter.service
sudo systemctl enable jetbot_jupyter
sudo systemctl start jetbot_jupyter

python3 create_stats_service.py
sudo mv jetbot_stats.service /etc/systemd/system/jetbot_stats.service
sudo systemctl enable jetbot_stats
sudo systemctl start jetbot_stats
