// import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/contact_bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/contact_repository.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository = new ContactRepository();

  ContactBloc() : super(ContactUninitialized()) {
    on<RefreshContactEvent>(_mapRefreshContactToState);
  }

  // @override
  // Stream<ContactState> mapEventToState(ContactEvent event) async* {
  //   //
  //   if (event is RefreshContactEvent) {
  //     yield* _mapRefreshContactToState(event);
  //   } else {
  //     //
  //   }
  // }

  void _mapRefreshContactToState(
      RefreshContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      // final List<Contact> contactList = await contactRepository.getContacts();
      // yield ContactLoadSuccess(contactList);
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ContactLoadError());
    }
  }
}
