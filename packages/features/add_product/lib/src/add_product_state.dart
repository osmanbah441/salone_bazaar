part of 'add_product_cubit.dart';

class AddProductState extends Equatable {
  const AddProductState({
    this.productName = const ProductName.unvalidated(),
    this.productDescription = const ProductDescription.unvalidated(),
    this.productPrice = const ProductPrice.unvalidated(),
    this.productImage = const ProductImage.unvalidated(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  final ProductName productName;
  final ProductDescription productDescription;
  final ProductPrice productPrice;
  final ProductImage productImage;
  final SubmissionStatus submissionStatus;

  AddProductState copyWith({
    ProductName? productName,
    ProductDescription? productDescription,
    ProductPrice? productPrice,
    ProductImage? productImage,
    SubmissionStatus? submissionStatus,
  }) {
    return AddProductState(
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productPrice: productPrice ?? this.productPrice,
      productImage: productImage ?? this.productImage,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        productName,
        productDescription,
        productPrice,
        productImage,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  genericError;

  bool get isSuccess => this == SubmissionStatus.success;
  bool get isInProgress => this == SubmissionStatus.inProgress;
  bool get isGenericError => this == SubmissionStatus.genericError;
}
