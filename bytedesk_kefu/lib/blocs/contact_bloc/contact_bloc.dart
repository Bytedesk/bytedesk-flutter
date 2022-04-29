import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/contact_bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/contact_repository.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository = new ContactRepository();

  // ContactBloc({@required this.contactRepository});
  ContactBloc() : super(ContactUninitialized());

  // @override
  // ContactState get initialState => ContactUninitialized();

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    //
    if (event is RefreshContactEvent) {
      yield* _mapRefreshContactToState(event);
    } else {
      //
    }
  }

  Stream<ContactState> _mapRefreshContactToState(
      RefreshContactEvent event) async* {
    yield ContactLoading();
    try {
      // final List<Contact> contactList = await contactRepository.getContacts();
      // yield ContactLoadSuccess(contactList);
    } catch (error) {
      print(error);
      yield ContactLoadError();
    }
  }
}
