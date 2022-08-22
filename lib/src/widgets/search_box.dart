part of '../../aveochat.dart';

Widget SearchBox(
  BuildContext context,
  TextEditingController searchController, {
  required clearSearch,
  required bool allowUserSearch,
  required String searchHint,
}) {
  return allowUserSearch
      ? Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  hintText: searchHint,
                  filled: true,
                  suffixIcon: searchController.text.trim().isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => clearSearch(),
                        )
                      : const Icon(Icons.search, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(54.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  searchController.text = val;
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
