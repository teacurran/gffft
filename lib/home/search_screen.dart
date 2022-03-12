import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/components/search_input_sliver.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../gfffts/models/gffft_minimal.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key, required this.searchController}) : super(key: key);

  final PagingController searchController;

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return CustomScrollView(
      slivers: <Widget>[
        SearchInputSliver(onChanged: (searchTerm) => _updateSearchTerm(searchTerm), label: l10n!.gffftListSearchHint),
        PagedSliverList<String?, GffftMinimal>(
          pagingController: _searchController,
          builderDelegate: PagedChildBuilderDelegate<GffftMinimal>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description ?? item.name),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GffftHomeScreen(uid: item.uid, gid: item.gid);
                    }));
                  },
                  trailing: getTrailingItems(theme, l10n, item)),
              noItemsFoundIndicatorBuilder: (_) => SearchNotFound()),
        ),
      ],
    );
  }
}
