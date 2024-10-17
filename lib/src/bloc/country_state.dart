part of 'country_cubit.dart';

abstract class CountryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<Country> countries;

  CountryLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountryError extends CountryState {
  final String message;

  CountryError(this.message);

  @override
  List<Object> get props => [message];
}
