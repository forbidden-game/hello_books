import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellobooks/constant/constants.dart';
import 'package:hellobooks/helper/user_helper.dart';
import 'package:hellobooks/model/data.dart';
import 'package:hellobooks/service/service.dart';
import 'package:hellobooks/widgets/toast.dart';
import 'package:image_picker/image_picker.dart';

/// 发布图书页面
class PublishPage extends StatefulWidget {
  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final GlobalKey formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File _image;

  /// 从相册或者相机获取图片
  Future<void> _getImage(ImageSource imgSource) async {
    var image = await ImagePicker.pickImage(source: imgSource);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发布图书"),
      ),
      // 如果不用 SingleChildScrollView 包起来，弹出键盘时会报出边界越界异常
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: _getPictureWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _inputWidget(),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取顶部图片区域视图
  Widget _getPictureWidget() {
    var widget;
    if (_image == null) {
      widget = Padding(
        padding: const EdgeInsets.only(left: 80.0, right: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: ListTile(
                leading: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                title: Text(
                  "拍照",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                _getImage(ImageSource.camera);
              },
            ),
            Container(
              height: 20,
            ),
            RaisedButton(
              child: ListTile(
                leading: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                ),
                title: Text(
                  "从相册选择",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      widget = Image.file(_image);
    }
    return widget;
  }

  /// 下方输入书籍信息部分布局
  Widget _inputWidget() {
    return Form(
      //设置globalKey，用于后面获取FormState
      key: formKey,
      //开启自动校验
      autovalidate: false,
      child: Padding(
        padding: const EdgeInsets.all(BookPadding.pagePadding),
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: false,
              controller: nameController,
              decoration: InputDecoration(
                hintText: "书名",
                icon: Icon(Icons.book),
              ),
              // 校验用户名
              validator: (v) {
                return v.trim().length > 0 ? null : "书名不能为空";
              },
            ),
            TextFormField(
              autofocus: false,
              controller: descController,
              decoration: InputDecoration(
                hintText: "简介",
                icon: Icon(Icons.description),
              ),
              // 校验用户名
              validator: (v) {
                return v.trim().length > 0 ? null : "简介不能为空";
              },
            ),
            Padding(
              padding: const EdgeInsets.all(BookPadding.pagePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _categoryWidget(),
                  _productTypeWidget(),
                ],
              ),
            ),
            _buildPriceInputWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 100.0,
                ),
                child: Text("提交", style: TextStyle(fontSize: 16.0)),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  // 通过_formKey.currentState 获取FormState后，
                  // 调用validate()方法校验用户名密码是否合法，校验通过后再提交数据。
                  if ((formKey.currentState as FormState).validate()) {
                    _submitProduct(
                      name: nameController.text,
                      desc: descController.text,
                      category: _selectedCategory == null
                          ? BookCategory.unknown.toString()
                          : _selectedCategory.toString(),
                      price: ProductType.rent == _selectedProductType
                          ? int.parse(priceController.text)
                          : 0,
                      image: _image,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  BookCategory _selectedCategory;

  Widget _categoryWidget() {
    var categoryItems = BookCategory.values
        .map((category) => DropdownMenuItem<BookCategory>(
              value: category,
              child: Text(category.convertToChinese()),
            ))
        .toList();
    return DropdownButton(
      value: _selectedCategory,
      items: categoryItems,
      onChanged: (category) {
        setState(() {
          _selectedCategory = category;
        });
      },
      hint: Text("选择图书类别"),
    );
  }

  ProductType _selectedProductType;

  Widget _productTypeWidget() {
    var typeItems = ProductType.values
        .map((type) => DropdownMenuItem<ProductType>(
              value: type,
              child: Text(type.convertToChinese()),
            ))
        .toList();
    return DropdownButton(
      value: _selectedProductType,
      items: typeItems,
      onChanged: (type) {
        setState(() {
          _selectedProductType = type;
        });
      },
      hint: Text("选择商品类型"),
    );
  }

  Widget _buildPriceInputWidget() {
    if (ProductType.rent == _selectedProductType) {
      return TextFormField(
        autofocus: false,
        controller: priceController,
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        //只允许输入数字
        decoration: InputDecoration(
          hintText: "价格",
          icon: Icon(Icons.attach_money),
        ),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : "请填写价格";
        },
      );
    } else {
      return Container();
    }
  }

  Future<void> _submitProduct({
    String name,
    String desc,
    String category,
    String productType,
    int price,
    File image,
  }) async {
    var bookServer = BookServer();
    var productServer = ProductServer();
    try {
      var bmobFile = await bookServer.uploadBookPicture(image);
      var book = Book(
        name: nameController.text,
        desc: descController.text,
        category: category,
        price: price,
        picture: bmobFile,
        imgUrl: bmobFile.url,
      );
      var bookSaved = await bookServer.uploadBook(book);
      book.objectId = bookSaved.objectId;
      var curUser = await UserHelper.getCurUser();
      var product = Product(
        bookId: book.getObjectId(),
        userId: curUser.getObjectId(),
        book: book,
        user: curUser,
        type: productType,
      );
      var productSaved = await productServer.uploadProduct(product);
      BookToast.toast("提交成功");
    } catch (e) {
      BookToast.toast("提交失败：$e");
    }
  }
}
