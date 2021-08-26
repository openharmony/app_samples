import router from '@system.router';

export default {
    data: {
        title: ""
    },
    onInit() {
        this.title = this.$t('strings.page');
    },
    pushPage(){
        router.push({
            uri:"pages/pushPage/index",
            params:{
                data1:
                    this.$t('strings.value')
                }

        })
    }
}
