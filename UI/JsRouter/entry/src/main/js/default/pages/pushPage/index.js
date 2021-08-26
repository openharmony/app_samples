import router from '@system.router';

export default {
    data:{
    data1:"default"
    },
    replacePage(){
        router.replace({
            uri:"pages/replacePage/index"
        })
    }
}