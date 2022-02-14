import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/link_sets/models/link_set_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/link_preview.dart';
import 'link_set_api.dart';
import 'link_view_horizontal.dart';
import 'link_view_vertical.dart';
import 'models/link.dart';

final getIt = GetIt.instance;

class LinkPreviewCard extends StatefulWidget {
  final String url;
  final LinkSetItem? linkSetItem;

  const LinkPreviewCard({Key? key, required this.url, this.linkSetItem});

  @override
  State<LinkPreviewCard> createState() => _LinkPreviewCardState();
}

class _LinkPreviewCardState extends State<LinkPreviewCard> {
  LinkSetApi linkSetApi = getIt<LinkSetApi>();

  String? _errorImage, _errorTitle, _errorBody;
  bool _loading = false;
  bool _linkValid = false, _proxyValid = true;

  String? errorImage;
  String? errorTitle;
  String? errorBody;
  String? errorText;
  Widget? errorWidget;
  Widget? placeholderWidget;
  Duration cache = const Duration(days: 1);
  bool showMultimedia = true;
  final UIDirection displayDirection = UIDirection.UIDirectionHorizontal;

  Link? _link;

  @override
  void initState() {
    _errorImage = errorImage ?? 'https://github.com/sur950/any_link_preview/blob/master/lib/assets/giphy.gif?raw=true';
    _errorTitle = errorTitle ?? 'Something went wrong!';
    _errorBody = errorBody ??
        'Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!';

    _linkValid = AnyLinkPreview.isValidLink(widget.url);

    if (_linkValid) {
      _loading = true;
      _getInfo();
    }
    super.initState();
  }

  Future<void> _getInfo() async {
    if (widget.linkSetItem == null) {
      _link = await linkSetApi.getLink(widget.url);
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget _buildPlaceHolder(Color color, double defaultHeight) {
    return Container(
      height: defaultHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        var layoutWidth = constraints.biggest.width;
        var layoutHeight = constraints.biggest.height;

        return Container(
          color: color,
          width: layoutWidth,
          height: layoutHeight,
        );
      }),
    );
  }

  Widget _buildLinkContainer(ThemeData theme, double _height) {
    return Container(
      height: _height,
      child: (displayDirection == UIDirection.UIDirectionHorizontal)
          ? LinkViewHorizontal(
              key: widget.key ?? Key(widget.url.toString()),
              url: widget.url,
              title: widget.linkSetItem?.title ?? _link?.title ?? widget.url,
              description: widget.linkSetItem?.description ?? _link?.description ?? '',
              imageUri: widget.linkSetItem?.image ?? _link?.image ?? '',
              onTap: () => _launchURL(widget.url),
              titleTextStyle: theme.textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold),
              bodyTextStyle: theme.textTheme.bodyText1,
              bodyTextOverflow: TextOverflow.ellipsis,
              bodyMaxLines: 5,
              showMultiMedia: showMultimedia,
              bgColor: theme.backgroundColor,
              radius: 8,
              author: widget.linkSetItem?.author,
            )
          : LinkViewVertical(
              key: widget.key ?? Key(widget.url.toString()),
              url: widget.url,
              title: widget.linkSetItem?.title ?? _link?.title ?? '',
              description: widget.linkSetItem?.description ?? _link?.description ?? '',
              imageUri: widget.linkSetItem?.image ?? _link?.image ?? '',
              onTap: () => _launchURL(widget.url),
              titleTextStyle: theme.textTheme.headline3,
              bodyTextStyle: theme.textTheme.bodyText1,
              bodyTextOverflow: TextOverflow.ellipsis,
              bodyMaxLines: 5,
              showMultiMedia: showMultimedia,
              bgColor: theme.backgroundColor,
              radius: 8,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    var _height = (displayDirection == UIDirection.UIDirectionHorizontal || !showMultimedia)
        ? ((MediaQuery.of(context).size.height) * 0.15)
        : ((MediaQuery.of(context).size.height) * 0.25);

    Widget _loadingErrorWidget = Container(
      height: _height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      alignment: Alignment.center,
      child: Text(
        !_linkValid
            ? 'Invalid Link'
            : !_proxyValid
                ? 'Proxy URL is invalid. Kindly pass only if required'
                : 'Fetching data...',
      ),
    );

    if (_loading)
      return (!_linkValid || !_proxyValid) ? _loadingErrorWidget : (placeholderWidget ?? _loadingErrorWidget);

    return widget.linkSetItem == null && _link == null
        ? errorWidget ?? _buildPlaceHolder(theme.backgroundColor, _height)
        : _buildLinkContainer(theme, _height);
  }
}
