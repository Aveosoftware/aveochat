part of '../../melos_chat.dart';

Widget SearchBox(BuildContext context,
    {required bool allowUserSearch, required String searchHint}) {
  return allowUserSearch
      ? Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  hintText: searchHint,
                  filled: true,
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(54.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  await showSearch(
                    context: context,
                    delegate: TheSearch(),
                    query: "",
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
          ],
        )
      : const SizedBox(
          height: 12.0,
        );
}
