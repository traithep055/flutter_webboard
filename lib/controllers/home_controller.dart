import 'package:get/get.dart';
import '../models/post_model.dart';

class HomeController extends GetxController {
  var posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() {
    posts.value = [
      PostModel(
        title: 'แนะนำหนังพจญภัย',
        author: 'Josh',
        date: '04/11/67',
        content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s,',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi_fbx2Kyr6F0F5gOlyIG1FXJb-ZEDod5Kzw&s',
      ),
      PostModel(
        title: 'ประโยชน์ของการเรียน',
        author: 'John',
        date: '05/11/67',
        content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
        imageUrl: '',
      ),
      PostModel(
        title: 'flutter คือะไร',
        author: 'gojo',
        date: '06/11/67',
        content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry kjkjfdjfoekfskdfskdfksjfksdfjvmdkmvldfmdmfkdsmkdmfksdmfkdsmkdsmfkdsmfkdsmfkdsmfkdmfkmfdkfmkdsfmfdmdsfkdmdkmmdvdfdfdfdfdfdfdfdfdefgmkmkgrgkrkfjferfklkfkerjfklerjrefklerjfklerjfirejfierjfijerifjerifjerijferijfefjerfierfioerjfrejfjerjfioerjfierjfierjfierjfioerjfioerjfioerjfierjkenv',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi_fbx2Kyr6F0F5gOlyIG1FXJb-ZEDod5Kzw&s',
      ),
      PostModel(
        title: 'อยากนอน',
        author: 'ฺบอส',
        date: '06/11/67',
        content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry นอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอนอน',
        imageUrl: '',
      ),
    ];
  }
}
