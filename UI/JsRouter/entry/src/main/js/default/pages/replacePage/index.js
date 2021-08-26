import router from '@system.router';

export default {
    data:{
        dataValue:''
    },
    onInit(){
       this.dataValue = this.$t('strings.replace')
    },
    backPage(){
        router.back({
            uri:"pages/index/index"
        });
    }
}