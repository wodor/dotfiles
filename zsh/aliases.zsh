alias dx-fapi='docker-compose exec fantasysport-api-web'
alias dx='docker-compose exec'
dx-artisan() {
	cd ~/code/rush/fantasysport-api;
	docker-compose exec fantasysport-api-web php artisan; 
	cd -
}
alias dx-mysql='mysql -h127.0.0.1 -P 33061 -u root -proot fantech'

alias wodor-env='set -a;. ./.env.wodor;set +a'

alias stop='spotify stop'
alias play='spotify play'
# alias last-dev-task="aws ecs describe-tasks --cluster rally-dev --tasks `aws ecs list-tasks --cluster rally-dev | jq -r '. | .taskArns[0]'` | jq -r '. |  .tasks[0].taskDefinitionArn'"

alias k=kubectl
alias h=helm
alias kg='kubectl get'
alias kcf='kubectl create -f'
alias hi='helm install'
alias hid='helm install --dry-run'
alias drit='docker run --rm -it'
alias weather='curl http://wttr.in/manchester'
alias dc='docker-compose'
alias dcps='docker-compose ps'
alias dcr='docker-compose run'
alias dce='docker-compose exec'
