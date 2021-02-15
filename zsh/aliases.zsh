alias dx-fapi='docker-compose exec fantasysport-api-web'
alias dx='docker-compose exec'
dx-artisan() {
	cd ~/code/rush/fantasysport-api;
	docker-compose exec fantasysport-api-web php artisan; 
	cd -
}

alias stop='spotify stop'
alias play='spotify play'

