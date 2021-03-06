#!/bin/bash
# author: naodongbanana
# url:www.github.com/YueNing


# setting the variables
source_url=$1
source_name='sources.zip'
#mysql_root_password=$2
mysql_user_name='mk_user'
mysql_password='test123'
source_dir='my_video_scenes_tmp'
godown_link='https://raw.githubusercontent.com/YueNing/AI_View/master/deploy_scripts/demos/godown.pl'

# get the source file id
IFS=? read -a full_id <<< $source_url
id=${full_id[1]:3}

install_homebrew(){
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

init(){
	mkdir ~/AI_View && cd ~/AI_View
	wait
	echo 'source ./medienkunst_python3_virtualenv/bin/activate' > start.sh
	echo 'cd mk && python3 manage.py runserver' >> start.sh && chmod +x start.sh
}

# download the system tools
download_system_tools() {
	brew install wget python3 ffmpeg git subversion unzip
	brew install mysql
	brew tap homebrew/services
	wait
	brew services start mysql
	pip3 install virtualenv
	wait
	#wget -O gdrive https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download &
}


# get the ai system source code
get_source_code() {
	cd ~/AI_View
	svn export https://github.com/YueNing/AI_View.git/trunk/mk 
	svn export https://github.com/YueNing/AI_View.git/trunk/pre_data
}

#get_source_code
download_source_file() {
	mkdir my_video_scenes_tmp &
	#./gdrive download $id
	wget $godown_link
	wait
	chmod +x ./godown.pl &
	wait
	./godown.pl $source_url $source_name
	wait
	unzip $source_name -d $source_dir && rm $source_name
	wait
	mv my_video_scenes_tmp/data_ai_view.xlsx pre_data
}

#python3 virtualenv
python3_virtualenv() {
	cd ~/AI_View
	mkdir medienkunst_python3_virtualenv && virtualenv --no-site-packages -p "/usr/local/bin/python3" medienkunst_python3_virtualenv 
	wait
	source ./medienkunst_python3_virtualenv/bin/activate
	wait
	pip3 install -r mk/requirements.txt
}


# setting mysql create new user and new database
mysql_setting() {
	MYSQL=`which mysql`
	sudo $MYSQL -uroot<< EOF
	CREATE DATABASE mk;
	CREATE USER 'mk_user'@'localhost' identified by 'test123';
	GRANT ALL ON *.* TO 'mk_user'@'localhost';
	FLUSH PRIVILEGES;
EOF
}

substuation_mk_setting() {
	cd mk/static &&
	sed -i '' 's~.*STATICFILES_DIRS.*~STATICFILES_DIRS = ('"'"$(pwd)"'"',)~' ../mk/settings.py &&
	cd ../../
}

django_setting() {
	substuation_mk_setting
	wait
	cd mk && python3 manage.py makemigrations && python3 manage.py migrate && python3 manage.py createsuperuser && 
	wait
	cd ../pre_data && python3 ./save.py
	wait
	cd ../ && ./start.sh
}

install_homebrew
init
download_system_tools
get_source_code
python3_virtualenv
download_source_file
mysql_setting
django_setting



