const BOOKS = [
  { title: 'My diary', introduction: 'I am happy today', image: $r('app.media.book_img1') },
  { title: 'Cat', introduction: 'I have a cat', image: $r('app.media.book_img2') },
  { title: 'Happy', introduction: 'Have fun every day', image: $r('app.media.book_img3') },
  { title: 'Sentiment', introduction: 'I\'m not angry', image: $r('app.media.book_img4') },
  { title: 'Tree', introduction: 'Small tree observation diary', image: $r('app.media.book_img1') },
  { title: 'I am very kind', introduction: 'I am very kind', image: $r('app.media.book_img2') },
  { title: 'Seahorse Daddy', introduction: 'Big-bellied hippocampus dad', image: $r('app.media.book_img3') },
  { title: 'Butterfly', introduction: 'Butterfly', image: $r('app.media.book_img4') },
  { title: 'Good friend', introduction: 'Good friends are with you all your life', image: $r('app.media.book_img1') }
]

class DataModel {
  private books: Array<{
    title: string,
    introduction: string,
    image: Resource
  }> = BOOKS

  constructor() {
  }

  query(key: string) {
    let result: Array<{
      title: string,
      introduction: string,
      image: Resource
    }> = []
    this.books.forEach((item) => {
      if (item.title.match(key) || item.introduction.match(key)) {
        result.push(item)
      }
    })
    return result
  }

  getAllData(){
    return this.books
  }
}

export default new DataModel()